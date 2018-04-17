<?php

//Editar respuestas*

require('Control/core.php');
//OnlineUsers();

if(isset($_GET['view'])) {
  if(file_exists('Control/Controllers/' . $_GET['view'] . 'Controller.php')) {
    include('Control/Controllers/' . $_GET['view'] . 'Controller.php');
  } else {
  	echo "no estas".$_GET['view'];
 include('Control/Controllers/' . $_GET['view'] . 'Controller.php');
   //include('Control/Controllers/errorController.php');
  }
} else {
  echo "no";
 // include('core/controllers/indexController.php');
}

?>
