 <?php
if(!empty($_POST['evento']))
	{

		$evento=$_POST['evento'];

		switch ($evento) {
			case 'eliminar':
				$idord=$_POST['idord'];

					$ordenes=new Ordenes();
		

					$o=$ordenes->get_deleteorden($idord,$user['US_C_CODIGO']);
									


										  // $url="../Vistas/registro_secciones.php?nom=".$nomproy;
										 $sms='<div class="alert alert-success alert-dismissible">
			                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			                            <h4><i class="icon fa fa-check"></i>'.$o[0].' </h4> Sin Problemas, Gracias.</div>';

									

					include(HTML_DIR .'ordenes/listarordenes.php');
				break;

			case 'modificar':
				
					$codigo=$_POST['codigo'];
					$nombre=$_POST['nombre'];
					$apell=$_POST['apell'];
					$correo=$_POST['correo'];
					$pass=$_POST['pass'];
					$sede=$_POST['sede'];
					$idsede=$_POST['idsede'];
					$img=$_POST['img'];
					
					include(HTML_DIR .'usuarios/modificarUsuarios.php');

				break;

			case 'actualizar':

					$user=new User();
		

					$id=$_POST['codigo'];
					$nombre=$_POST['nombre'];
					$apell=$_POST['apell'];
					$correo=$_POST['correo'];
					$pass=$_POST['pass'];
					$sede=$_POST['sede'];
					$img=$_POST['imgmod'];
					

					$msg="";
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
							$img=$file_name;}

					$u=$user->update_usuario($id,$nombre,$apell,$correo,$pass,$sede,$img);
					if($u['sms']=='ok'){


										  // $url="../Vistas/registro_secciones.php?nom=".$nomproy;
										 $sms='<div class="alert alert-success alert-dismissible">
			                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			                            <h4><i class="icon fa fa-check"></i>'.$u['sms'].' </h4>'.$msg.' Sin Problemas, Gracias.</div>';

									}
									else{
										 $sms=' <div class="alert alert-danger alert-dismissible">
			                              <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
			                              <h4><i class="icon fa fa-ban"></i> Error!</h4>'.$u['sms'].'</div>';
			                           
									}

					include(HTML_DIR .'usuarios/listarUsuarios.php');


				break;
			case 'vistas':
					$codigo=$_POST['id'];
					$nombre=$_POST['nombre'];
					$apell=$_POST['apell'];

			include(HTML_DIR .'vistas/asignar.php');
			break;


			default:
				include(HTML_DIR .'usuarios/listarUsuarios.php');
				break;
		}
		


} else{

	include(HTML_DIR .'ordenes/listarordenes.php');
}
?>