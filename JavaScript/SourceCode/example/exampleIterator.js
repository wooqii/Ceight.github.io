(function () {
    var nav = document.createElement('nav'),
        previous = document.createElement('a'),
        next = document.createElement('a'),
        current = document.createElement('strong'),
        ref = document.body.children[0];

        tVar = location.href.split('/'),
        this_file = tVar[ tVar.length - 1 ],
        index = 0;

    for (var i = examples.length - 1; i >= 0; i--) {
        if (examples[i] === this_file) {
            index = i;
            break;
        }
    }
        

    current.innerHTML = this_file;

    if (index == 0) {
        previous.href = '';
        previous.innerHTML = 'this is the first example';
        previous.style.color = '#777';
        previous.style.textDecoration = 'none';
    } else {
        previous.href = examples[index - 1];
        previous.innerHTML = examples[index - 1];
    }

    if (index == examples.length - 1) {
        next.href = '';
        next.innerHTML = 'this is the last example';
        next.style.color = '#777';
        next.style.textDecoration = 'none';
    } else {
        next.href = examples[index + 1];
        next.innerHTML = examples[index + 1];
    }

    current.style.margin =
    previous.style.margin =
    next.style.margin = '10px';

    nav.appendChild(previous);
    nav.appendChild(current);
    nav.appendChild(next);
    nav.style.display = 'block';
    nav.style.padding = '8px';
    nav.style.border = '3px solid #eee';
    nav.style.margin = '8px auto';
    document.body.insertBefore(nav, ref);
})();

(function () {
    var scripts = document.getElementsByTagName('script'),
        s = null;
    for (var i = 0; i < scripts.length; i++) {
        s = scripts[i];

        if (!s.src) {
            var pre = document.createElement('pre');
            pre.innerHTML = s.innerHTML;
            pre.style.background = '#eee';
            document.body.appendChild(pre);
        }
    }
})();