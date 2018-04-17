
<ul class="sidebar-menu">
        <li class="header">MENU DE NAVEGACIÓN</li>
        
         <?php 
         $idus=$usuario['US_C_CODIGO'];
        $per = new Permisos();
        $result=$per->user_menu2($idus,0);
         while($fila=$result->fetch_array()){  
         
              if($fila['VIS_P_PADRE']==0)
                 { //active
                  ?>

                 <li class="treeview ">
                  <a href="#">

                    <i class="<?php echo $fila['VIS_I_IMG'];?>"></i> <span> <?php echo $fila['VIS_D_NOMBRE']; ?></span> <i class="fa fa-angle-left pull-right"></i>
                       </a> 
                       
                       
                                 
                      <?php
                             $per->user_sub_menu2($idus,$fila['VIS_C_CODIGO'],$activ);

                      ?>
                     

                </li>
          
              <?php 

                }
            }     

          ?>
        
   
  </ul>

