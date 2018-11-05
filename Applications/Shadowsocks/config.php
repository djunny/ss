<?php
// 服务器地址
$SERVER = '0.0.0.0';
// 加密算法
$METHOD = 'aes-256-cfb';
// 密码
$PASSWORD = 'mz888';
// 服务器端口
$PORT = 48888;
// 客户端端口
$LOCAL_PORT = 1080;
// 启动多少进程
$PROCESS_COUNT = 3;


$conf_file = '../../conf';
if(is_file($conf_file)){
	$conf_content = trim(file_get_contents($conf_file));
	$conf_content = preg_replace('#[\r\n]+#is', '&', $conf_content);
	parse_str($conf_content,$conf);
	foreach($conf as $key=>$val){
		$$key = $val;
	}
}