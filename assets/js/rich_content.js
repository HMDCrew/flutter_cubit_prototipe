// do przelaczania specyfikacji
// dolaczane w html creatorze
function switchSpecs() {
    var todayElements = document.getElementsByClassName('ui-seemore__panelarea'), i;
    for (let i = 0; i < todayElements.length; i += 1) {
        if (todayElements[i].style.display == 'none') {

            todayElements[i].style.display = 'block';
        } else {

            // dlatego ze inicjalnie display ustawiany jest w arkuszu
            var displayValue = getStyle(todayElements[i], "display");
            if (displayValue === 'none') {
                todayElements[i].style.display = 'block';
            } else {
                todayElements[i].style.display = 'none';
            }
        }
    }
};

function getStyle(x, styleProp) {
    if (x.currentStyle)
        var y = x.currentStyle[styleProp];
    else if (window.getComputedStyle)
        var y = document.defaultView.getComputedStyle(x, null).getPropertyValue(styleProp);
    return y;
}

// hot spots
function otSelectdemoFeature(index) {
    var instruction = document.getElementsByClassName("instruction");
    for (let i = 0; i < instruction.length; i += 1) {
        instruction[i].style.display = 'none';
    }

    var demos = document.getElementsByClassName("demo-copy");
    for (let i = 0; i < demos.length; i += 1) {
        if (i === index) {
            demos[i].style.display = 'block';
        } else {
            demos[i].style.display = 'none';
        }
    }
}

function otSelectBackToStart() {
    var demos = document.getElementsByClassName("demo-copy");
    for (let i = 0; i < demos.length; i += 1) {
        demos[i].style.display = 'none';
    }
    var instruction = document.getElementsByClassName("instruction");
    for (let i = 0; i < instruction.length; i += 1) {
        instruction[i].style.display = 'block';
    }

}

// color variations
function showColor(index) {
    var images = document.querySelectorAll(".product-specs__img-colors__panels .product-specs__img img");
    var panels = document.querySelectorAll(".product-specs__img-colors__panels");
    var buttons = document.getElementsByClassName("product-specs__colors__list__item");
    var defaultImg = document.querySelectorAll(".product-specs__img-colors__default");

    for (let i = 0; i < defaultImg.length; i += 1) {
        defaultImg[i].style.opacity = 0;
    }

    for (let i = 0; i < panels.length; i += 1) {
        panels[i].style.display = 'block';
    }

    for (let i = 0; i < images.length; i += 1) {
        if (i === index) {
            images[i].style.display = 'block';
        } else {
            images[i].style.display = 'none';
        }
    }
}

// hotspot new template
var descriptions = document.querySelectorAll(".contents-demo__details__item");
var numIns = document.querySelectorAll('.contents-demo__num__in');
var bigImages = document.querySelectorAll(".contents-demo__img__list__item__img");

for (let i = 0; i < numIns.length; i += 1) {
    numIns[i].addEventListener('click', ev => {
        ev.preventDefault();
        clickNumIn(ev);
    });
}

function clickNumIn(e) {
    e = e || window.event;
    var target = e.target || e.srcElement,
        text = target.textContent || target.innerText;
    var clickedNumber = text;

    for (let i = 0; i < descriptions.length; i += 1) {
        descriptions[i].style.display = 'none';
        bigImages[i].style.opacity = '0';

        if (i + 1 == clickedNumber) {
            descriptions[i].style.display = 'block';
            bigImages[i].style.opacity = '100';
        }
    }
}
