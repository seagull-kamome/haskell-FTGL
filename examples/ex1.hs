{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad (unless)
--import Control.Concurrent (threadDelay)
import qualified Data.Text.Encoding as T

import Graphics.Rendering.FTGL as FTGL
import Graphics.UI.GLFW as GLFW
import Graphics.Rendering.OpenGL as GL


main :: IO ()
main = do
  GLFW.init >>= flip unless (fail "Failed to initialize GLFW")

  fnt <- FTGL.createExtrudeFont "examples/gothic.ttf"
  FTGL.setCharMap fnt FTGL.EncodingUnicode
  _ <- FTGL.setFontFaceSize fnt 7 7
  FTGL.setFontDepth fnt 1.0

  GLFW.windowHint $ GLFW.WindowHint'Resizable False
  Just win <- GLFW.createWindow 640 480 "FTGL haskell - ex1" Nothing Nothing
  GLFW.makeContextCurrent $ Just win

  GLFW.swapInterval 1
  GL.clearColor $= Color4 1.0 1.0 1.0 1.0
  let loop = GLFW.windowShouldClose win >>= flip unless go
      go = do
        GL.clear [GL.ColorBuffer]
        GL.loadIdentity
        
        GL.scale 0.01 0.01 (0.5 :: GLdouble)
        GL.color $ Color4 1.0 0 0 (1.0 :: GLdouble)
        FTGL.renderFont fnt (T.encodeUtf8 "Hello, 日本語はすける") FTGL.All

        GL.translate $ Vector3 0.0 7.0 (0.0 :: GLdouble)
        FTGL.renderFont fnt "GLFW+FTGL" FTGL.All

        GL.translate $ Vector3 (-100) 7.0 (0.0 :: GLdouble)
        FTGL.renderFont fnt (T.encodeUtf8 "文字列の左下が原点で、上はY+。横はX+方向。Z=0平面に描かれる？") FTGL.All

        GLFW.swapBuffers win
        --threadDelay 200
        loop
    in loop

  GLFW.destroyWindow win

  FTGL.destroyFont fnt
  
  GLFW.terminate
  return ()
