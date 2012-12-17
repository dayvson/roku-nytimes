function showVideoDetailScreen(allVideos as object, indexSelected as integer) As Boolean
    port=CreateObject("roMessagePort")
    screen = CreateObject("roSpringboardScreen")
    screen.SetDescriptionStyle("video") 
    screen.SetMessagePort(port)

    preroll = {
        streamFormat: "mp4"
        stream: {
          url:  "http://stream-hlg03.terra.com.br/intel5s.mp4"
        }
    }
    
    screen.SetStaticRatingEnabled(false)
    screen.SetPosterStyle("rounded-rect-16x9-generic")
    screen.AllowNavLeft(true)
    screen.AllowNavRight(true)
    screen.SetAdURL("http://graphics8.nytimes.com/adx/images/ADS/30/72/ad.307295/REV_PeggyBank.jpg", "http://graphics8.nytimes.com/adx/images/ADS/30/72/ad.307295/REV_PeggyBank.jpg")
    screen.SetAdDisplayMode("scale-to-fill")
    screen.AllowUpdates(true)
    updateDetailScreen(screen, allVideos[indexSelected])
    screen.Show()
    remoteKeyLeft  = 4
    remoteKeyRight = 5    
    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roSpringboardScreenEvent"
            if msg.isScreenClosed()
                print "Screen closed"
                exit while
            else if msg.isRemoteKeyPressed()
                if msg.GetIndex() = remoteKeyLeft then
                    indexSelected = getPrevVideo(allVideos, indexSelected)
                    setCookie("indexSelected", Stri(indexSelected))
                    updateDetailScreen(screen, allVideos[indexSelected])
                else if msg.GetIndex() = remoteKeyRight
                    indexSelected = getNextVideo(allVideos, indexSelected)
                    setCookie("indexSelected", Stri(indexSelected))
                    updateDetailScreen(screen, allVideos[indexSelected])
                end if
            else if msg.isButtonPressed()
                print "Button pressed: "; msg.GetIndex(); " " msg.GetData()
                if msg.GetIndex() = 1
                    canvas = CreateObject("roImageCanvas")
                    canvas.SetLayer(0, "#000000")
                    canvas.Show()
                    if ShowPreroll(preroll)
                        ShowVideoScreen(allVideos[indexSelected])
                    end if
                    canvas.Close()
                endif
                if msg.GetIndex() = 2
                    return true
                endif
            else
                print "Unknown event: "; msg.GetType(); " msg: "; msg.GetMessage()
            endif
        else
            print "wrong type.... type=";msg.GetType(); " msg: "; msg.GetMessage()
        endif
    end while
    return true
end function

function updateDetailScreen(screen As Object, videoSelected As Object) As Void
    screen.ClearButtons()
    screen.AddButton(1,"Watch in HD")
    screen.AddButton(2,"Back")
    screen.SetContent(videoSelected)
    screen.Show()
end function


function getNextVideo(videos As Object, index As Integer) As Object
    nextIndex = index + 1
    if nextIndex >= videos.Count() or nextIndex < 0 then
       nextIndex = 0 
    end if
    return nextIndex
end Function

function getPrevVideo(videos As Object, index As Integer) As Object
    prevIndex = index - 1
    if prevIndex < 0 or prevIndex >= videos.Count() then
        prevIndex = videos.Count() - 1 
    end if
    return prevIndex
end function
