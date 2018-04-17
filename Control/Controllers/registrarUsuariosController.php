<?php
if(isset($_SESSION['usuario'])) {

if(!empty($_POST['nombre']) and !empty($_POST['apell']) and !empty($_POST['correo']) and !empty($_POST['pass']) and !empty($_POST['sede'])){
$nombre=$_POST['nombre'];
$apell=$_POST['apell'];
$correo=$_POST['correo'];
$pass=$_POST['pass'];
$sede=$_POST['sede'];
$img=$_FILES['img']['name'];
$cookie_name = "error";
$user=new User();

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
						$u=$user->register_user($nombre,$apell,$correo,$pass,$sede,$img);
						if($u['sms']=='ok'){


							  // $url="../Vistas/registro_secciones.php?nom=".$nomproy;
							 $sms='<div class="alert alert-success alert-dismissible">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                            <h4><i class="icon fa fa-check"></i>'.$u['sms'].' </h4> Sin Problemas, Gracias.</div>';

							// setcookie($cookie_name, $sms, time() + 9, "/"); 

							 include(HTML_DIR .'usuarios/registrarUsuarios.php');
						}
						else{
							 $sms=' <div class="alert alert-danger alert-dismissible">
                              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
                              <h4><i class="icon fa fa-ban"></i> Error!</h4>'.$u['sms'].'</div>';
                               
							
							 //setcookie($cookie_name,$sms, time() + 9, "/"); 
						  	 
							 include(HTML_DIR .'usuarios/registrarUsuarios.php');
						}
						
						if($uploadedfileload=="true"){
										move_uploaded_file ($_FILES['img']['tmp_name'], "Public/img/Usuarios/".$add);
										//echo "<h1 align='center'> Ha sido subido satisfactoriamente</h1>";
									}

					
				}

	
	}else
	{
		include(HTML_DIR .'usuarios/registrarUsuarios.php');
	}


}else
{
	echo "no tiene permisos";
}
//$db->close();
?>