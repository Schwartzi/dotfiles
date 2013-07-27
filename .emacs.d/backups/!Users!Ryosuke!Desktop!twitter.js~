// Character code of this file is utf-8.
// kono fairu no mojiko-do ha utf-8 desu.
// このファイルの文字コードはutf-8です。

// 2010/11/29 ツイートの中のURLを自動でリンクにするようにしました。
// 2010/10/13 たくさんコメント追加しました。

twdata =new Array();
var page = 0;
var fin = 0;
var end = 0;
var kazu = 15; // あらかじめ先読みしておくつぶやきの数。たぶん、30くらいにしても取得する速度はほとんど変わらない
var dsp = 2; //１ページに表示する数
var user = "ts_3156"; // ここを自分のユーザ名に変えてください

// ツイートの日付の書式を整える。「2010/10/13 ( 17:50 )」みたいな書式になる。
function relative_time(time_value) {
	time_values = time_value.split(" ");
	time_value = time_values[1]+" "+time_values[2]+", "+time_values[5]+" "+time_values[3];
	var parsed_date = Date.parse(time_value);
	var relative_to = (arguments.length > 1) ? arguments[1] : new Date();
	var delta = parseInt((relative_to.getTime() - parsed_date) / 1000);
	delta = delta + (relative_to.getTimezoneOffset()*60);
	var dt = new Date();
	dt.setTime(dt.getTime() - (delta*1000));
	yy = dt.getYear();
	mm = dt.getMonth() + 1;
	dd = dt.getDate();
	dy = dt.getDay();
	hh = dt.getHours();
	mi = dt.getMinutes();
	ss = dt.getSeconds();

	if (yy < 2000) yy += 1900;
	if (mm < 10) mm = "0" + mm;
	if (dd < 10) dd = "0" + dd;
	dy = new Array("Sun","Mon","Tue","Wed","Thu","Fri","Sat")[dy];
	if (hh < 10) hh = "0" + hh;
	if (mi < 10) mi = "0" + mi;
	if (ss < 10) ss = "0" + ss;
	return yy + "/" + mm + "/" + dd + " ( " + hh + ":" + mi + " )";
}

// 2010/11/29 ツイートの中にURLがあったら、自動でリンクにする。要望を受けて作成
// 2012/10/14 httpsの場合もリンクになるように修正
// 別のタブで開くようにしてますが、同じタブで開きたい場合は、「target='_blank'」を削除してください。
function create_link(tw_text) {
	return tw_text.replace(/((http|https):\/\/[\x21-\x7e]+)/gi, "<a href='$1' target='_blank'>$1</a>");
}

// ツイッターからデータを取得すると自動的に呼ばれる。「@」で始まるツイートは省くようにしてます。
// 特定の人へのリプライを表示してもつまんないですよね？
function twitterCallback(obj) {

	var i = 0;
	var j = 0;
	while (i < obj.length && j < kazu ){
		if(obj[i].text.substr(0, 1) != '@'){
			twdata[j] = obj[i];
			j++;
		}
		i++;
	}
	fin = j;

	hyouji();
}

// idがtwitterのタグの中に、ツイートを挿入する。
function hyouji(){
	var tw = document.getElementById('twitter');
	var cnt = 0;
	end = 0;

	for ( i= page * dsp ; cnt<dsp ; i++) {
		tw.innerHTML += '<p class="tw_text">'+create_link(twdata[i].text)+'</p><p class="tw_day">' + relative_time(twdata[i].created_at)+'</p>';
		cnt++;
		if(fin-1 == i)
			end = 1;
	}
}

// 「次へ」、「前へ」ボタンを押したら呼ばれる。
// 表示されるツイートの数と先読みしたツイートの数が一致しない時がある理由は、
// 「@」で始まるので省かれているツイートがあるからです。
function twbtn(flg){
	var tw = document.getElementById('twitter');

	if(flg=='next' && end == 0){
		tw.innerHTML ='';
		page++;
		hyouji();
	}
	else if(flg=='back'&& page > 0){
		page--;
		tw.innerHTML ='';
		hyouji();
	}
}

document.write(
'<script type="text/javascript" ' +
'src="https://api.twitter.com/1/statuses/user_timeline.json?screen_name=' + user + '&count=' + kazu + '&callback=twitterCallback"></script>'
);
