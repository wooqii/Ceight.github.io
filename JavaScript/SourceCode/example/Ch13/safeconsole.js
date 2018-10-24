/*!
 * safeconsole.js - 인터넷 익스플로러에서 console.log()를 사용하는 스크립트
 * 한선용 (aka 검은태양) - http://tranbot.net/util/safeConsole/
 * 2012.05.17 최종수정
 * 수정과 재배포에는 아무 제한도 없으니 자유롭게 사용하십시오.
 */
window.KIP = {};          //네임스페이스 구실을 할 객체 생성
KIP.safeConsole = {};

//브라우저에서 콘솔을 지원하면 아무 일도 하지 않고 빠져나갑니다.
//더미 함수는 이 스크립트 이전 버전과의 호환성을 위해 만듭니다.
if (window.console) {
    window.initConsole = function () {};
} else {

    //전역 변수 console을 객체로 선언합니다. var를 쓰면 안됩니다.
    console = {};

    console.log = function () {
    //매개변수 배열에서 루프를 돌며 output()을 호출해 문자열로 바꾸고
    //li 요소에 넣은 다음 콘솔에 삽입합니다. 
        var kc = document.getElementById('console4IE'),
            ul, li, rtn,
            args = arguments;     

        if (kc) {
            ul = kc.getElementsByTagName('ul')[0]
            for (var i = 0; i < args.length; i += 1) {
                li = document.createElement('li');
                rtn = output(args[i]);                
                li.innerHTML = rtn;
                ul.appendChild(li);
            }
        }        
    }

    console.trueType = function trueType(object) {
        //넘겨받은 매개변수의 type을 반환합니다.
        var rtn = '';
        switch (typeof object) {

        //typeof 연산자가 object를 반환하는 경우 네이티브 Object 타입의
        //toString() 메서드를 이용해 정확한 타입을 알아냅니다.
        //자세한 내용은 Professional Javascript for Web Developers(인사이트, 2013)
        //22장을 참고하십시오.
        case 'object':
            rtn = Object.prototype.toString
                        .call(object)
                        .split(' ')[1]
                        .replace(']', '')
                        .toLowerCase();
            break;

        //typeof 연산자는 NaN의 타입도 number라고 반환하므로 이를 보정합니다.
        case 'number':
            rtn = isNaN(object)? 'nan': 'number';
            break;
        default:
            rtn = typeof object;
            break;
        }
        return rtn;
    }

    console.buildBuffer = function buildBuffer(obj) {
        //객체의 프로퍼티와 그 값을 나열할 때 abc 순서로 정렬하기 위해
        //제공하는 매개변수 배열입니다.
        //프로퍼티 이름 중 가장 긴 이름의 길이(max)도 반환합니다.
        var buffer = [],
            max = 0;
        for (property in obj) {
            if (property.length > max) { max = property.length; }
            buffer.push(property);
        }
        if (max < 4) {max = 4}
        return {
            arr: buffer.sort(),
            max: max
        };
    }

    console.output = function output(object) {
        //넘겨받은 매개변수의 타입에 따라 적절한 html을 생성하여 반환합니다.
        //배열과 객체는 확장해서 내용을 볼 수 있는데, 토글 트리거인 a 요소와
        //내용이 표시되는 ul/ol 요소를 매칭하기 위해 카운터를 썼습니다.
        //카운터 구실을 하는 요소는 #counter이고 숨어 있습니다.
        //즉 a와 ul은 다음과 같이 대응합니다.
    /*
        <a href="#c1"></a> 
        <ul id="c1" style="display:none">
          ...
        </ul>
    */
        var counter = document.getElementById('counter'),
            previousCount = counter.value * 1,
            currentCount = 'c' + (previousCount + 1),
            type = console.trueType(object),
            typeName = {
                'string':   '문자열',
                'number':   '숫자',
                'object':   '객체',
                'array':    '배열',
                'function': '함수',
                'empty':    '빈 문자열',
                'boolean':  '불리언',
                'false':    '불리언'
            }[type],
            aTag = '<a',
            tVar = '';

        //매개변수가 배열일 경우 배열의 길이를 타입 옆에 쓰도록 했습니다.
            tVar = typeName? 
                        typeName + (type == 'array'? '[' + o.length + ']': ''): 
                        type;

        //매개변수가 null이나 undefined인 경우 warning 클래스로 강조합니다.
        if ( /(?:nan|null|undefined)/.exec(typeName) ) {
            aTag += ' class="warning"';
        }

        //매개변수 타입은 a 요소에 들어가며 배열과 객체일 때는 토글 트리거가
        //되도록 위에서 정의한 카운터를 href 속성에 삽입합니다.
        if ( /^(?:arr|obj)/.exec(type) ) { aTag += ' href="#' +currentCount+ '"' }
        aTag += ('>' + tVar + '</a>');

        var v = '',
            buffer = {},
            arr, max;

        //위에서 설명한대로 객체와 배열의 프로퍼티를 담는 ol 요소를 생성합니다.
        switch(type) {
        case 'array':   counter.value = previousCount + 1;
                        v = '[<ol id="' +currentCount+ '" style="display:none">';
                        for (var i = 0; i < object.length; i++) {
                            v += '<li>' + output( object[i] ) + '</li>';
                        }
                        v += '</ol>]';
                        break;

        //객체의 경우 배열과 별로 다를 것은 없으나 프로퍼티 이름 중 가장 긴 것을
        //취해 그 길이에 맞게 너비를 정하는 부분이 있어 다소 복잡해 보입니다.
        //프로퍼티 이름에는 보통 영문을 쓰므로 가장 긴 길이에 0.75를 곱했는데,
        //개발할 때 프로퍼티 이름으로 한글을 많이 사용한다면 max*0.75를 그냥
        //max라고만 쓰면 한글 이름에 문제가 생기지 않을겁니다.
        case 'object':  counter.value = previousCount + 1;
                        buffer = this.buildBuffer(object);
                        arr = buffer.arr;
                        max = buffer.max
                        v = '{<ul id="' +currentCount+ '" style="display:none">';
                        for (var i = 0; i < arr.length; i++) {
                            v += '<li>' + 
                                   '<a style="display:inline-block;' +
                                             'width:' + max*0.75 + 'em">' +
                                     arr[i] + ': ' +
                                   '</a>' +
                                   output( o[ arr[i] ] ) +
                                 '</li>'
                        };
                        v += '</ul>}';
                        break;

        //띄어쓰기가 유지되게끔 스페이스를 &nbsp; 문자로 바꿨습니다.
        //간혹 스페이스가 여러 개 들어가며 이 숫자가 중요할 때가 있습니다.
        //이런 경우 공백이 몇개인지 쉽게 알 수 있도록 title 속성으로
        //공백문자의 갯수를 표시했습니다.
        case 'string':  v = '<b class="string">"' +
                                o.replace(/ /g, '&nbsp;')
                                 .replace(/(?:&nbsp;){2,}/g, function ($1) {
                                    var l = $1.length / 6 + 1;
                                    return '<span title="공백 ' +l+ '개">' +
                                        $1 + '</span>';
                                  })
                                   +
                            '"</b>';
                        break;

        //매개변수가 불리언이나 함수, 숫자인 경우 .toString()을
        //호출하고 적절한 클래스를 붙입니다. CSS에서 이들 타입의 색깔이나
        //표시 형태를 자유롭게 바꿀 수 있습니다.
        case 'boolean': 
        case 'function':
        case 'number':
                        v = '<b class="' +type+ '">' + o.toString() + '</b>';
                        break;

        //undefined, null, NaN은 이미 처리한 상태입니다.
        default:        v = '';
        }
        return aTag + v;
    }

}

    console.init = function init() {

        function isTesting() {
        //주소 표시줄을 읽어서 현재 테스트중이라면 true를, 실서버로 판단된다면
        //false를 반환합니다. 로컬호스트 세팅이 다르거나 원격 서버에서 테스트하시는
        //분은 여기를 수정하십시오.
            var h = location.href;
            if (h.indexOf('file://') >= 0 || 
                h.indexOf('http://localhost') >= 0 || 
                h.indexOf('http://127.0.0.1') >= 0) {
                return true;
            } else {
                return false;
            }
        }

        function initializeConsole() {
            if ( document.getElementById('console4IE') ) { return false; }
            //#console4IE 요소가 이미 있다면 다른 script 요소에서
            //initConsole()을 호출한 것으로 간주하고 아무 일도 하지 않습니다.

            var console4IE = document.createElement('div'),
                consoleToggle = document.createElement('p'),
                consoleUl = document.createElement('ul');

            consoleUl.id = 'consoleUl'
            consoleToggle.id = 'consoleToggle';
            consoleToggle.innerHTML =
                '직접 입력: ' +
                '<textarea id="manualConsole" rows="1" '+
                          'title="입력 내용은 eval()을 거쳐 아래 콘솔에 표시됩니다">' +
                '</textarea>' +
                '<button id="manualConsoleSubmit">확인</button>' +
                '<button id="clearConsole">지움</button>' +
                '<button id="toggleConsole">콘솔 토글</button>' +
                '<input type="hidden" id="couter" value="0">';

            console4IE.id = 'console4IE';
            console4IE.style.height = '400px';
            console4IE.appendChild(consoleToggle);
            console4IE.appendChild(consoleUl);
            document.body.appendChild(console4IE);
            //다음 마크업을 만듭니다.
    /*
            <div id="console4IE">
              <p id="consoleToggle">
                <button id="toggleConsole">콘솔 토글</button>
                <button id="clearConsole">지움</button>
                <input type="hidden" id="couter" value="0">
              </p>
              <ul id="consoleUl"></ul>
            </div>        
    */
            //이전 버전에서는 요소마다 onclick 이벤트 핸들러를 연결했으므로
            //처리할 일이 많아서 성능 부담이 있었고 코드도 길었지만 이번
            //업데이트에서는 이벤트 위임을 활용해서 이벤트 핸들러를 IE용 콘솔 div
            //하나에서 전부 처리하도록 개선했습니다. 
            //이제 반복문에서 console.log()를 호출해도 성능 부담이 없습니다.

            //단, 이 코드에서는 간결함을 위해
            //"네이티브 콘솔이 없다면 반드시 attachEvent가 있다"라고 가정하고
            //작성했습니다. 현실적으로 사용하는 브라우저 중 네이티브 콘솔을
            //지원하지 않는 브라우저는 IE 뿐이고 5부터 9까지 모두 attachEvent를 
            //지원하므로 문제는 없습니다.
            var kc = document.getElementById('console4IE');
            kc.attachEvent('onclick', function (e) {
                var target = e.srcElement,
                    id = target.id,
                    href = target.href,
                    manual = document.getElementById('manualConsole');
                if (id) {
                    switch (id) {
                    case 'toggleConsole':
                          kc.style.height = kc.style.height == '30px'? 
                                            '400px': '30px';
                          target.blur();
                          break;
                    case 'clearConsole':
                          kc.removeChild(
                              document.getElementById('consoleUl')
                          );
                          target.blur();
                          break;
                    case 'manualConsoleSubmit':
                          console.log( eval(manual.value) );
                    }
                }
                if (href) {
                    href = href.replace(/^[^#]*?#/, '');
                    var ul = document.getElementById(href);
                    ul.style.display = 
                        ul.style.display == 'none'? 'block': 'none';
                    return false;
                }
            }, false);
        }    
        if (isTesting()) {
            //로컬호스트에서 실행하거나 파일을 더블클릭해 실행하는 경우입니다.
            window.attachEvent('onload', initializeConsole);
            //어떤 이유로 로딩이 늦어지더라도 콘솔 에러가 나지 않게끔 이후의 모든 
            //스크립트를 15밀리초 기다린 뒤에 실행하도록 했습니다.
            window.setTimeout(function(){}, 15);
        } else {
            //실서버인 경우입니다. console.log()를 더미 함수로 대체해서
            //모든 명령을 무시하게 만듭니다.
            console.log = function (text) {};
            console.expand = function (text) {};
        }
    }

window.initConsole = KIP.safeConsole.init;