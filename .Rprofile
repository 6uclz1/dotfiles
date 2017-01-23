## CRAN ミラーを指定
options(repos=list(CRAN="https://cran.rstudio.com/"));

## 起動時にロードするパッケージを追加
local({
    pkgs <- getOption("defaultPackages");
    options(defaultPackages=c(pkgs, "lattice", "car"));
});

## 零和対比をデフォルトに設定
## car::Anova(type="III") が SPSS と一致するようになる
options(contrasts=c("contr.sum", "contr.sum"));

## Mac OS X 環境では Quartz 描画をデフォルトに設定
if(capabilities("aqua")) {
    options(device="quartz");
}


## グラフィックスデバイスにフォント設定フックを追加
setHook(packageEvent("grDevices", "onLoad"), function(...) {

    ## Windows 環境のフォント設定
    if (.Platform$OS.type == "windows") {

        ## フォントデータベースはデフォルトのまま
        grDevices::windowsFonts(
            serif = grDevices::windowsFont("TT Times New Roman"),
            sans  = grDevices::windowsFont("TT Arial"),
            mono  = grDevices::windowsFont("TT Courier New")
        );

        ## フォントデータベースに明朝体とゴシック体を追加
        grDevices::windowsFonts(
            mincho = grDevices::windowsFont("TT MS Mincho"),
            gothic = grDevices::windowsFont("TT MS Gothic")
        );
        grDevices::postscriptFonts(
            mincho = grDevices::postscriptFonts()$Japan1,
            gothic = grDevices::postscriptFonts()$Japan1GothicBBB
        );
        grDevices::pdfFonts(
            mincho = grDevices::pdfFonts()$Japan1,
            gothic = grDevices::pdfFonts()$Japan1GothicBBB
        );
    }

    ## Mac OS X 環境のフォント設定
    if (capabilities("aqua")) {
        grDevices::quartzFonts(
            serif = grDevices::quartzFont(c("Hiragino Mincho Pro W3",
                                            "Hiragino Mincho Pro W6",
                                            "Hiragino Mincho Pro W3",
                                            "Hiragino Mincho Pro W6")),
            sans  = grDevices::quartzFont(c("Hiragino Kaku Gothic Pro W3",
                                            "Hiragino Kaku Gothic Pro W6",
                                            "Hiragino Kaku Gothic Pro W3",
                                            "Hiragino Kaku Gothic Pro W6"))
        );
    }

    ## Linux 環境のフォント設定
    if (capabilities("X11")) {
        grDevices::X11.options(fonts=c(
            "-kochi-gothic-%s-%s-*-*-%d-*-*-*-*-*-*-*",
            "-adobe-symbol-medium-r-*-*-%d-*-*-*-*-*-*-*"));
    }

    ## PostScript と PDF のフォント設定
    ## family="" で描画した文字列に使われる
    grDevices::ps.options (family="Japan1GothicBBB");
    grDevices::pdf.options(family="Japan1GothicBBB");

});

## 日本語を設定するための環境を作成
attach(NULL, name="JapanEnv");

## フォントを設定するフック関数を定義
assign("familyset_hook", function() {
    winfontdevs = c("windows", "win.metafile", "png",
                    "bmp", "jpeg", "tiff", "RStudioGD");
    macfontdevs = c("quartz", "quartz_off_screen", "RStudioGD");
    devname = strsplit(names(dev.cur()), ":")[[1L]][1];
    if ((.Platform$OS.type == "windows") && (devname %in% winfontdevs)) {
        par(family="gothic");
    }
    if (capabilities("aqua") && (devname %in% macfontdevs)) {
        par(family="sans");
    }
}, pos="JapanEnv");

## 作図関数にフォント設定フックを追加
setHook("plot.new", get("familyset_hook", pos="JapanEnv"));
setHook("persp",    get("familyset_hook", pos="JapanEnv"));
