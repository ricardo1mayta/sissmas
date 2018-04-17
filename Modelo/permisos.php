<?php

//include_once '../config.ini.php';

class Permisos{

private $db;

public function __construct() 
{
        $this->db = new Conexion();
        
}
	
    
   
    public function user_menu($uid) {
        $menu=$this->db->query("SELECT * FROM dg_vista_menu WHERE US_C_CODIGO='$uid' AND PER_E_ESTADO=1");
       
        return $menu;

       /* $menudata= mysql_fetch_array($menu);
        $_SESSION['menu'] = $menudata;*/
    }
    public function user_sub_menu($uid,$idpad) {

        $menu=$this->db->query("SELECT DISTINCT * FROM dg_vista_menu WHERE US_C_CODIGO='$uid' AND VIS_P_PADRE='$idpad' AND PER_E_ESTADO=1");
        
        return $menu;

       /* $menudata= mysql_fetch_array($menu);
        $_SESSION['menu'] = $menudata;*/
    }


   
    public function user_menu1($idus,$idpad) {
        $sql="select  v.VIS_C_CODIGO,v.VIS_D_NOMBRE from dg_permisos p inner join dg_vistas v on v.VIS_C_CODIGO = p.VIS_C_CODIGO WHERE p.US_C_CODIGO='$idus' AND p.PER_E_ESTADO=1 AND v.VIS_P_PADRE='$idvis'";
        $menu=$this->db->query($sql);
       
        return $menu;

      
    }
    public function user_sub_menu1($idus,$idpad) {
        $sql="select  v.VIS_C_CODIGO,v.VIS_D_NOMBRE from dg_permisos p inner join dg_vistas v on v.VIS_C_CODIGO = p.VIS_C_CODIGO WHERE p.US_C_CODIGO='$idus' AND p.PER_E_ESTADO=1 AND v.VIS_P_PADRE='$idpad'";
        $result=$this->db->query($sql);
        ?>
       <ul class="">
               <?php  while($lista=$result->fetch_array()){ ?>                      
                        
                          <li class=""><?php echo $lista["VIS_D_NOMBRE"] ?> </li>
                               <?php   $this->user_sub_menu1($idus,$lista["VIS_C_CODIGO"]);?>
                                 
                          
                        
                        
                    <?php } ?>
         
                </ul>
    <?php   
    }
    public function user_menu2($idus,$idpad) {
        $sql="select  v.VIS_C_CODIGO,v.VIS_D_NOMBRE,v.VIS_L_ENLACE,v.VIS_I_IMG from dg_permisos p inner join dg_vistas v on v.VIS_C_CODIGO = p.VIS_C_CODIGO WHERE p.US_C_CODIGO='$idus' AND p.PER_E_ESTADO=1 AND v.VIS_P_PADRE='$idvis'";
        $menu=$this->db->query($sql);
       
        return $menu;

      
    }
    public function user_sub_menu2($idus,$idpad) {
        $sql="select  v.VIS_C_CODIGO,v.VIS_D_NOMBRE,v.VIS_L_ENLACE,v.VIS_I_IMG from dg_permisos p inner join dg_vistas v on v.VIS_C_CODIGO = p.VIS_C_CODIGO WHERE p.US_C_CODIGO='$idus' AND p.PER_E_ESTADO=1 AND v.VIS_P_PADRE='$idpad'";
        $result=$this->db->query($sql);
        ?>
      <ul class="treeview-menu">
               <?php  while($lista=$result->fetch_array()){ ?>                      
                        
                          <li ><a href="<?php echo '../'.$lista['VIS_L_ENLACE'].'/'; ?>" target="_self"><i class="fa fa-circle-o"></i><?php echo $lista['VIS_D_NOMBRE']; ?> </a>
                          </li>       
                               <?php   $this->user_sub_menu2($idus,$lista["VIS_C_CODIGO"]);?>
                                 
                          
                        
                        
                    <?php } ?>
         
      </ul>
    <?php   
    }

    public function save_permiso($idus,$idvis)
    {
        $sql="call sp_agrega_vista('$idvis','$idus')";
         $result=$this->db->query($sql);  
        
    
        return $result;

        
    }


}

?>
