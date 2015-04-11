<?php
use PhpOffice\PhpWord\Autoloader;
use PhpOffice\PhpWord\Settings;
use PhpOffice\PhpWord\IOFactory;

require_once __DIR__ . '/PhpWord/Autoloader.php';
Autoloader::register();
Settings::loadConfig();

date_default_timezone_set('PRC');
$writers = array('Word2007' => 'docx');

$fpipe = fopen("php://stdin", "r"); 
$filename = chop(fgets($fpipe));
$rawname = explode('.', $filename)[0];
fclose($fpipe);

$fout = fopen($filename, 'r');
$phpWord = new \PhpOffice\PhpWord\PhpWord();

$phpWord->addTitleStyle(1, array(
    'name' => '宋体',
    'size' => 14,
    'bold' => true
));

$htStyle = array(
    'name' => '宋体',
    'size' => 32
);
$hpStyle = array(
    'align' => 'center'
);

$ttStyle = array(
    'name' => '宋体',
    'size' => 12
);

$tpStyle = array(
    'align' => 'left',
    'indent' => 1
);

$pattern = "/^(一|二|三|四|五|六|七|八|九|十|十一|十二)月$/";
$date_pattern = "/^[0-9]+月[0-9]+日/";
$virgin = true;

$section = $phpWord->addSection();

while(!feof($fout)){
    $line = fgets($fout);
    if (strlen($line) == 1)
        continue;
    if ($virgin) {
        $section->addText($line, $htStyle, $hpStyle);
        $virgin = false;
    }
    else if (preg_match($pattern, $line) > 0) {
        $section->addTitle($line, 1);
    }
    else if (preg_match($date_pattern, $line) > 0) {
    	$section->addTextBreak();
		$section->addText($line, $ttStyle, $tpStyle);
    }
	else
        $section->addText($line, $ttStyle, $tpStyle);
}

foreach ($writers as $writer => $extension) {
    if (!is_null($extension)) {
        $xmlWriter = IOFactory::createWriter($phpWord, $writer);
        $xmlWriter->save("{$rawname}.{$extension}");
		return 0;
    } else {
		return -1;
    }
}
fclose($fout);
?>
