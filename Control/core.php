<?php
/*
  EL NÚCLEO DE LA APLICACIÓN!
*/

session_start();
$user=$_SESSION['usuario'];
date_default_timezone_set("America/Lima");
 $hoy = date("Y-m-d H:i:s");

#Constantes de conexión

require('config.ini.php');

#Constantes de la APP
define('HTML_DIR','Vistas/');
define('APP_TITLE','SISSMAS.COM');
define('APP_COPY','Copyright &copy; ' . date('Y',time()) . ' Ocrend Software.');
define('APP_URL','localhost:90/OcrendBB/'); //Adaptado a mi nuevo entorno con Ubuntu
//require('vendor/autoload.php');
require('Modelo/conexion.php');
require('Modelo/usuario.php');
require('Modelo/permisos.php');
require('Modelo/sedes.php');
require('Modelo/vistas.php');
require('Modelo/roles.php');
//require('Modelo/categoria.php');
//require('Modelo/marca.php');
require('Modelo/productos/productos.php');
require('Modelo/productos/marca.php');
require('Modelo/productos/categoria.php');
require('Modelo/clientes/clientes.php');
require('Modelo/provedores.php');
require('Modelo/detordenes.php');
require('Modelo/ordenes.php');
require('Modelo/funciones/numletras.php');
require('Modelo/creditos/creditos.php');
require('Modelo/tipopagos/tipopagos.php');
require('Modelo/reportes/reportes.php');
require('Modelo/gastos/gastos.php');
/*
#Constantes de PHPMailer
define('PHPMAILER_HOST','p3plcpnl0173.prod.phx3.secureserver.net');
define('PHPMAILER_USER','public@ocrend.com');
define('PHPMAILER_PASS','Prinick2016');
define('PHPMAILER_PORT',465);

#Constantes básicas de personalización
define('MIN_TITULOS_TEMAS_LONGITUD',9);
define('MIN_CONTENT_TEMAS_LONGITUD',270);

#Estructura
require('vendor/autoload.php');

require('core/bin/functions/Encrypt.php');
require('core/bin/functions/Users.php');
require('core/bin/functions/Categorias.php');
require('core/bin/functions/Foros.php');
require('core/bin/functions/EmailTemplate.php');
require('core/bin/functions/LostpassTemplate.php');
require('core/bin/functions/UrlAmigable.php');
require('core/bin/functions/BBcode.php');
require('core/bin/functions/OnlineUsers.php');
require('core/bin/functions/GetUserStatus.php');
require('core/bin/functions/IncreaseVisita.php');

$_users = Users();
$_categorias = Categorias();
$_foros = Foros();
*/
?>
