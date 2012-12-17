function Main() as void
    initTheme()
    showHomeScreen()
end function

function initTheme() as void
    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")
    theme = {
      OverhangPrimaryLogoOffsetSD_X: "0"
      OverhangPrimaryLogoOffsetSD_Y: "0"
      OverhangPrimaryLogoSD: "pkg:/images/Overhang_Background_SD.png"
      OverhangPrimaryLogoOffsetHD_X: "0"
      OverhangPrimaryLogoOffsetHD_Y: "0"
      OverhangPrimaryLogoHD: "pkg:/images/Overhang_Background_HD.png"
    }
    app.SetTheme(theme)
end function

