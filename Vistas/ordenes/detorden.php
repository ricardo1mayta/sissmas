<?php
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/detordenes.php"); 





if(isset($_REQUEST["id2"]) and isset($_REQUEST["id3"])){
  $idus = $_REQUEST["id"];
  $idord = $_REQUEST["id2"];
  $idpro = $_REQUEST["id3"];
  $can = $_REQUEST["id4"];
  $pv = $_REQUEST["id5"];
  $pc = $_REQUEST["id6"];
    $dtor = new detOrdenes();
  $save=$dtor->get_savedetorden($idpro,$can,$pc,$pv,$idord,$idus);
  (Double)$total=0;

  // lookup all hints from array if $q is different from "" 
  if ($save['sms']== "ok") { echo $save['sms']; ?>
    
  <?php }else {
  echo $save[0]; 
                  
  }
}else{
  $idord = $_REQUEST["id2"];

  echo "actualizado";
}
require("detallesordenes.php");
?>
          