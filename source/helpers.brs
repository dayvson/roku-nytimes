function readCookie(key, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key) then return sec.Read(key)
    return invalid
end function

function setCookie(key, val, section=invalid)
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
    sec.Flush()
end function

function CreateURLTransferObject(url As String) as Object
    obj = CreateObject("roUrlTransfer")
    obj.SetPort(CreateObject("roMessagePort"))
    obj.SetUrl(url)
    obj.AddHeader("Content-Type", "application/json")
    obj.EnableEncodings(true)
    return obj
end function

function URLLoader(url As String) as Object
    obj = CreateObject("roAssociativeArray")
    obj.Http                        = CreateURLTransferObject(url)
    obj.ReadDataWithRetry           = http_data_with_retry
    if Instr(1, url, "?") > 0 then obj.FirstParam = false
    return obj
end function

function http_data_with_retry() as String
    timeout%         = 1500
    num_retries%     = 5
    str = ""
    while num_retries% > 0
        if (m.Http.AsyncGetToString())
            event = wait(timeout%, m.Http.GetPort())
            if type(event) = "roUrlEvent"
                str = event.GetString()
                exit while
            elseif event = invalid
                m.Http.AsyncCancel()
                m.Http = CreateURLTransferObject(m.Http.GetUrl())
                timeout% = 2 * timeout%
            else
                print "roUrlTransfer::AsyncGetToString(): unknown event"
            endif
        endif
        num_retries% = num_retries% - 1
    end while
    return str
end function