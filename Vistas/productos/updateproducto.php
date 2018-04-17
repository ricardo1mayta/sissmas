<?php 
require('../../config.ini.php');
include("../../Modelo/conexion.php");
include("../../Modelo/productos/productos.php"); ?>
<?php 
$nombre=$_POST['nombre'];
$modelo=$_POST['modelo'];
$descripcion=$_POST['descripcion'];
$categoria=$_POST['categoria'];
$marca=$_POST['marca'];
$img=$_FILES['img']['name'];
$idus=$_POST['usuario'];
$idsede=$_POST['sede'];
$idpro=$_POST['id'];
$pv=$_POST['pv'];
$prod=new Productos();

if($img!=""){
$uploadedfileload="true";
$uploadedfile_size=$_FILES['img']['size'];

				if(	 $_FILES['img']['name']<>"" ){
					if ($_FILES['img']['size']>5000000)
						{ 
							$msg=$msg."El archivo es mayor que 5MB, debes reduzcirlo antes de subirlo<BR>";
							$uploadedfileload="false";
						}

						if (!($_FILES['img']['type'] =="image/jpeg" OR $_FILES['img']['type'] =="image/gif" OR $_FILES['img']['type'] =="image/png"))
						{$msg=$msg." Tu archivo tiene que ser JPG o GIF. Otros archivos no son permitidos ";
						$uploadedfileload="false";}

						$file_name=$_FILES['img']['name'];
						$add=$file_name;
						$u=$prod->update_producto($nombre ,$modelo ,$descripcion,$img ,$categoria ,$marca ,$idus,$idsede,$idpro,$pv);
						if($u['sms']=='ok'){

							echo  $sms=$u['sms'];
							  if($uploadedfileload=="true"){
										move_uploaded_file ($_FILES['img']['tmp_name'], "../../Public/img/productos/".$add);
										$msg.=" Ha sido subido satisfactoriamente";
									}

							echo  $sms=$u['sms'].$msg;

						}
						else{
							echo  $sms=$u['sms'].$msg;
                               
							
						}
						
						

				
				}

	
	}else
	{
		$u=$prod->update_producto($nombre ,$modelo ,$descripcion,$img ,$categoria ,$marca ,$idus,$idsede,$idpro,$pv);
echo "SMS: ".$u[0];
	}


 ?>