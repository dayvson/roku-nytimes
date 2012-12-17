function LoadVideoAPI() As Object
    conn = {
      urlAPI: "http://www.stg.nytimes.com/video/svc/devices/roku/1194811622184/index.html"
      LoadAPI: load_json
      GetVideos: getVideos
    }
    print "created api connection for " + conn.urlAPI
    return conn
end function

function load_json(conn As Object) As Dynamic
    loader = URLLoader(conn.urlAPI)
    data = loader.ReadDataWithRetry()
    json = ParseJson(data)
    videos = getVideos(json)
    return videos
end function


function getVideos(json As Object) As Object
    videos = VideoList()
    for each item in json.videos
		if item.rendition <> invalid
        	video = CreateVideo(item)
        	videos.Push(video)
		endif
    next
    return videos
end function

function VideoList() As Object
    videos = CreateObject("roArray", 100, true)
    return videos
end Function

function CreateVideo(videoItem As Object) As Object
    this = {
      id: videoItem.id
      sdPosterURL: videoItem.videoStillURL
      hdPosterURL: videoItem.videoStillURL
      title: videoItem.name
      description: videoItem.longDescription
      longDescription:videoItem.longDescription
      length: Stri(videoItem.rendition.duration / 1000).ToInt()
      stream: {
       url: videoItem.rendition.url
      }
      shortDescriptionLine1: videoItem.shortDescription
      shortDescriptionLine2: videoItem.longDescription
    }
    return this
end function