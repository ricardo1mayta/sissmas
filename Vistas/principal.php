

  <!-- Content Wrapper. Contains page content -->
  <?php  
  @include('links/titulo.php'); 
  @include('links/links.php'); 
  @include('links/header_menu.php'); 

   ?>
  <div class="content-wrapper" >
  <div class="content">
      <?php @include("bienvenido.php"); ?>
  </div>
  </div>
  
<?php 
@include_once('links/ajustes_generales.php');
@include_once('links/scrips.php');
@include_once('links/inferior_depues_cuerpo.php');
?>