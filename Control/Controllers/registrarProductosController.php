<?php
if(isset($_SESSION['usuario'])) {

if(!empty($_POST['nombre']) and !empty($_POST['modelo']) and !empty($_POST['descripcion']) and !empty($_POST['cantidad']) and !empty($_POST['preciocompra']) and !empty($_POST['precioventa']) and !empty($_POST['descuento']) and !empty($_POST['cantidadminima'])){
$nombre=$_POST['nombre'];
$modelo=$_POST['modelo'];
$descripcion=$_POST['descripcion'];
$cantidad=$_POST['cantidad'];
$preciocompra=$_POST['preciocompra'];
$precioventa=$_POST['precioventa'];
$descuento=$_POST['descuento'];
$cantidadminima=$_POST['cantidadminima'];
$categoria=$_POST['categoria'];
$marca=$_POST['marca'];
$img=$_FILES['img']['name'];
$idus=$_POST['usuario'];
$idsede=$_POST['sede'];
$cookie_name = "error";
$prod=new Productos();

$uploadedfileload="true";
$uploadedfile_size=$_FILES['img']['size'];

				if(	 $_FILES['img']['name']<>"" ){
					if ($_FILES['img']['size']>5000000)
						{ 
							$msg=$msg."El archivo es mayor que 5MB, debes reduzcirlo antes de subirlo<BR>";
							$uploadedfileload="false";
						}

						if (!($_FILES['img']['type'] =="image/jpeg" OR $_FILES['img']['type'] =="image/gif" OR $_FILES['img']['type'] =="image/png"))
						{$msg=$msg." Tu archivo tiene que ser JPG o GIF. Otros archivos no son permitidos<BR>";
						$uploadedfileload="false";}

						$file_name=$_FILES['img']['name'];
						$add=$file_name;
						$u=$prod->save_producto($nombre ,$modelo ,$descripcion ,$cantidad ,$preciocompra ,$precioventa ,$descuento ,$cantidadminima ,$img ,$categoria ,$marca ,$idus,$idsede);
						if($u['sms']=='ok'){


							  if($uploadedfileload=="true"){
										move_uploaded_file ($_FILES['img']['tmp_name'], "Public/img/productos/".$add);
										$msg.="<h1 align='center'> Ha sido subido satisfactoriamente</h1>";
									}

							 $sms='<div class="alert alert-success alert-dismissible">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                            <h4><i class="icon fa fa-check"></i>'.$u['sms'].' '.$msg.' </h4> Sin Problemas, Gracias.</div>';

							

							 include(HTML_DIR .'productos/registrarProductos.php');


						}
						else{
							 $sms=' <div class="alert alert-danger alert-dismissible">
                              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                              <h4><i class="icon fa fa-ban"></i> Error!</h4>'.$u['sms'].' '.$msg.'</div>';
                               
							
							 //setcookie($cookie_name,$sms, time() + 9, "/"); 
						  	 
							 include(HTML_DIR .'productos/registrarProductos.php');
						}
						
						

					
				}

	
	}else
	{
		include(HTML_DIR .'productos/registrarProductos.php');
	}


}else
{
	echo "no tiene permisos";
}
//$db->close();
?>