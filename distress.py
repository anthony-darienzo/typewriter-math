#!/usr/bin/env python

from posixpath import basename, join
from tkinter import W
from typing import List
import wand.image
import tempfile
import sys
import os
import subprocess
from shutil import which
from random import uniform,randint
from pdf2image import convert_from_path

OVERLAY_REF="./asset/fax_texture.jpg"
ARTIFACT_REF="./asset/artifacts.jpg"

def check_for_ghostscript():
  if which('gs') is not None:
    return True
  else:
    print("I need ghostscript to run, but I could not find it!")
    return False 

def exec_gs(cmd: List[str]) -> subprocess.CompletedProcess[str]:
  print("Running a GhostScript command.")
  return subprocess.run(cmd)

def verify_out(p: str) -> bool:
  if os.path.isdir(p):
    return True
  elif not os.path.isfile(p):
    print("Path {} did not exist, but I made it!".format(p))
    os.mkdir(p)
    return True
  else:
    return False

def make_gs_stub(s: str) -> List[str]:
  return [
    "gs",
    "-q",
    "-dNOSAFER",
    "-sPAPERSIZE=letter",
    "-dNOPAUSE",
    "-dBATCH",
    "-sDEVICE=pdfwrite",
    "-sOutputFile={}".format(s),
    "viewjpeg.ps",
    "-c"
    ]

# I don't think I need this. But it's here just in case.
def gs_shrink(p: str, o: str):
  gs_command = [ 
    "gs",
    "-sDEVICE=pdfwrite",
    "-dCompatibilityLevel=1.4",
    "-dPDFSETTINGS=/ebook",
    "-dNOPAUSE",
    "-dQUIET",
    "-dBATCH",
    "-sOutputFile={}".format(o),
    p
  ]
  exec_gs(gs_command)


def distress_pdf(path_to_pdf: str, out_path: str):
  the_basename = basename(path_to_pdf)
  gs_command = make_gs_stub( join(out_path,'{}_distressed.pdf'.format(the_basename)) )
  with tempfile.TemporaryDirectory() as path:
    image_paths = convert_from_path(path_to_pdf,output_folder=path,paths_only=True, dpi=150)
    with wand.image.Image(filename=OVERLAY_REF) as overlay, wand.image.Image(filename=ARTIFACT_REF) as artifacts_overlay:
      i = 0
      for p in image_paths:
        this_overlay = wand.image.Image(overlay)
        this_overlay.rotate(uniform(-5,5))
        with wand.image.Image(filename=p) as x:
          x.transform_colorspace('gray')
          x.rotate(uniform(-1,1))
          x.linear_stretch(0.0035,0.1) # flatten the colorspace?
          x.blur(0,0.5)
          x.noise(noise_type='gaussian',attenuate=0.45)
          x.composite(this_overlay,operator="overlay")
          h = randint(0,x.height)
          l = randint(0,x.width)
          x.composite(artifacts_overlay, operator="lighten",left=l, top=h)
          x.format = 'jpeg'
          new_p = "{}.jpeg".format(p)
          x.save( filename=new_p )
          gs_command.append( '("{}") viewJPEG showpage'.format(new_p) )
        i = i + 1
    # Now we should have a list of jpegs
    exec_gs(gs_command)

if __name__ == '__main__':
  if check_for_ghostscript() and verify_out(sys.argv[2]):
    distress_pdf(sys.argv[1],sys.argv[2])
  else:
    print("Something unexpected happened. Make sure all the checks should pass.")
    print("Goodbye!")
