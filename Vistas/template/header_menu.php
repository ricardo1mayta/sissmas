</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  <header class="main-header">
    <!-- Logo -->
    <a href="" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>G</b>Dg</span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b><?php echo $usuario['SED_D_NOMBRE'];?></b></span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>
        <div class="navbar-custom-menu">
          <ul class="nav navbar-nav">
            <!-- Messages: style can be found in dropdown.less-->
           
                
            <!-- User Account: style can be found in dropdown.less -->
            <li class="dropdown user user-menu">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <?php 
                echo "<img src=../Public/img/Usuarios/". $usuario['US_I_IMAGEN']." class='user-image' alt='User Image' >";
                ?>
                
                <span class="hidden-xs"><?php 
                    echo $usuario['US_D_NOMBRE']." " .$usuario['US_D_APELL'];
                  ?></span>
              </a>
              <ul class="dropdown-menu">
                <!-- User image -->
                <li class="user-header">
                 <?php 
                echo "<img src=../Public/img/Usuarios/". $usuario['US_I_IMAGEN']." class='img-circle' alt='User Image' >";
                ?>
                  <p><?php 
                    echo $usuario['US_D_NOMBRE']." " .$usuario['US_D_APELL'];
                    echo"<small> Desde: ".$usuario['US_F_FECHAINGRESO']."</small>" ?></p>
                    
                  <p>
                    
                    
                  </p>
                </li>
                
                <!-- Menu Body -->
                <li class="user-body">
                  <div class="row">
                    <div class="col-xs-4 text-center">
                      <a href="#">Tareas</a>
                    </div>
                    <div class="col-xs-4 text-center">
                      <a href="#">Informes</a>
                    </div>
                    <div class="col-xs-4 text-center">
                      <a href="#">Ediciones</a>
                    </div>
                  </div>
                  <!-- /.row -->
                </li>
                <!-- Menu Footer-->
                <li class="user-footer">
                  <div class="pull-left">
                    <a href="#" class="btn btn-default btn-flat">Perfil</a>
                  </div>
                  <div class="pull-right">
                    <a href="../" class="btn btn-default btn-flat">Salir</a>
                  </div>
                </li>
              </ul>
            </li>
            <!-- Control Sidebar Toggle Button -->
            <li>
              <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
            </li>
          </ul>
        </div>
     
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- Sidebar user panel -->
      <div class="user-panel">
        <div class="pull-left image">
          |   <?php 
             echo "<img src=../Public/img/Usuarios/". $usuario['US_I_IMAGEN']." class='img-circle' alt='User Image' >";
              ?>
          
        </div>
        <div class="pull-left info">
          <p><?php 
              echo $usuario['US_D_NOMBRE']." " .$usuario['US_D_APELL'];
              ?></p>
          <a href="#"><i class="fa fa-circle text-success"></i> En linea</a>
          <br>
        </div>
      </div>
      

      <!-- sidebar menu:con mysql : style can be found in sidebar.less -->
        <?php include('menu_navegacion.php') ?>

     
  </aside>
