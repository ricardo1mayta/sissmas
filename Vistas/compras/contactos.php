 <?php  
              require('../../config.ini.php');
              include("../../Modelo/conexion.php");
              include("../../Modelo/contactos/contactos.php");
         ?>
         <?php 
				$idempresa=$_REQUEST['e']; 
				$cp=new Contactos(); 

                      $cor=$cp->get_contacto($idempresa); 
                      if($idempresa>0) {?>

	
	<?php 
	
  while($row3=$cor->fetch_array()){

    ?>
    <option value="<?=$row3[0]?>"><?=$row3[1]?></option>  
    <?php } ?>

<?php } ?>

       

