<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/ordenes.php"); 
include("../../Modelo/detordenes.php"); 


$idord = $_REQUEST["id"];
$iddetor = $_REQUEST["id2"];
$op = $_REQUEST["id4"];
 $idus=$_REQUEST["id5"];


switch ($op) {
  case '1':
  $cant = $_REQUEST["id3"];
    $orde = new detOrdenes();
    $listas=$orde->get_editacandetorden($idord,$iddetor,$cant);
   
    break;
  
   case '2':
           $pre = $_REQUEST["id3"];
            $orde = new detOrdenes();
            $listas=$orde->get_editapredetorden($idord,$iddetor,$pre);
            
                          
    break;
 case '3':
         $orde = new detOrdenes();
          $listas=$orde->get_eliminadetorden($idord,$iddetor);
            
    break;

 case '4':
  $idord=$_REQUEST["id"];
  $idus=$_REQUEST["id2"];
         $orde = new Ordenes();
          $listas=$orde->get_deleteorden($idord,$idus);
            
    break;

   


}
echo  $listas[0];
include("detallesordenes.php");
?>
