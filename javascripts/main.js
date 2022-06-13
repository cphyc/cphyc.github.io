var currentLang = "en";

function setCVLang(lang) {
    if (lang == "fr") {
        $("#cv_en").hide();
        $("#cv_fr").show();
    } else if (lang == "en") {
        $("#cv_en").show();
        $("#cv_fr").hide();
    }
}
function toggleCVLang(buttonSelector) {
    if (currentLang == "en") {
        currentLang = "fr";
        $(buttonSelector).text("Show CV in English");
    } else {
        currentLang = "en";
        $(buttonSelector).text("Show CV in French");
    }
    setCVLang(currentLang);
}

$(document).ready(() => {
    setCVLang("en");

    $(".lazy-load").each((i, element) => {
        const me = $(element);
        const img = $("<div></div>");
        const text = $("<div>Click to reveal</div>");
        img.css({
            "background-image": `url("${me.data("background-url")}")`,
            "height": "100%",
            "width": "100%",
            "filter": "blur(5px)",
        });
        text.css({
            "position": "relative",
            "top": "-50%",
            "font-size": "larger",
        });
        [text, img].map((el) => {
            el.click(() => {
                me.html(`<iframe width="100%" style="aspect-ratio:2" src="${me.data("src")}"></iframe>`);
            });
        });
        me.append(img).append(text);
    });
});