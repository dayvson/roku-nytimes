function ShowVideoScreen(video as Object) As Void
  port = CreateObject("roMessagePort")
  screen = CreateObject("roVideoScreen")
  screen.SetMessagePort(port)
  screen.SetContent(video)
  screen.Show()
  while true
    msg = wait(0, port)
    if type(msg) = "roVideoScreenEvent"
      if msg.isScreenClosed()
        exit while
      end if
    end if
  end while
  screen.Close()
end function

function ShowPreRoll(video as Object)
  result = true
  canvas = CreateObject("roImageCanvas")
  player = CreateObject("roVideoPlayer")
  port = CreateObject("roMessagePort")
  canvas.SetMessagePort(port)
  player.SetMessagePort(port)
  player.SetDestinationRect(canvas.GetCanvasRect())
  player.AddContent(video)
  player.Play()
  while true
    msg = wait(0, canvas.GetMessagePort())
    if type(msg) = "roVideoPlayerEvent"
      if msg.isFullResult()
        ' the video played to the end without user intervention
        exit while
      else if msg.isStatusMessage()
        if msg.GetMessage() = "start of play"
          ' once the video starts, clear out the canvas so it doesn't cover the video
          canvas.SetLayer(0, { color: "#00000000", CompositionMode: "Source" })
          canvas.Show()
        end if
      end if
    else if type(msg) = "roImageCanvasEvent"
      if msg.isRemoteKeyPressed()
        index = msg.GetIndex()
        if index = 0 or index = 2
          ' the user pressed UP or BACK to terminate playback
          result = false
          exit while
        end if
      end if
    end if
  end while
  player.Stop()
  canvas.Close()
  return result
end function