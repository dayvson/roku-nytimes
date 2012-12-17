function showHomeScreen() As Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    screen.SetListStyle("arced-16x9")
    screen.setAdDisplayMode("scale-to-fit")
    
    video_list = getVideoList()
    screen.SetContentList(video_list)
    screen.Show()
    if video_list.Count() > 2 then
        if readCookie("indexSelected") <> invalid then
            screen.SetFocusedListItem(readCookie("indexSelected").ToInt())
        else
            screen.SetFocusedListItem(2)
        end if
    end if
    timer=createobject("rotimespan")
    timer.mark()
    refreshTime = 900000
    currentTime = 0
  
    while true
        msg = wait(20, screen.GetMessagePort())
        currentTime = currentTime + timer.totalmilliseconds()
        timer.mark()
        if currentTime > refreshTime then
          currentTime = 0
          video_list = getVideoList()
          updateScreen(screen, video_list)
        end if
        
        if type(msg) = "roPosterScreenEvent" then
            if msg.isListItemSelected() then
                print video_list
                showVideoDetailScreen(video_list, msg.GetIndex())
            else if msg.isScreenClosed() then
                return -1
            end if
        end If
    end while
    return 0
end function

function updateScreen(screen As Object, video_list as Object) As Void
  dialog = CreateObject("roOneLineDialog")
  dialog.SetTitle("Checking for new videos....")
  dialog.ShowBusyAnimation()
  dialog.Show()
  Sleep(2000)
  dialog.Close()
  screen.SetContentList(video_list)
  screen.Show()
end function

function getVideoList() As Object
    conn = LoadVideoAPI()
    video_list = conn.LoadAPI(conn)
    return video_list
end function
