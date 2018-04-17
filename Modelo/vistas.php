<?php

class Vistas {

private $db;

public function __construct() 
{
        
         $this->db = new Conexion();
       
}
	
   
public function register_user1($nombre,$apell,$correo,$pass,$sede,$img) 
{
      
		
		$sql = "call sp_insertar_usuario('$nombre','$apell','$correo','$pass','$sede','$img');";
        
       $rows=$this->db->query($sql);  
		$result=$rows->fetch_array();
	
		return $result;
		
		
    }

  

    public function get_allvistas($idpadre) 
	{
        $sql = "SELECT * FROM dg_vistas where VIS_P_PADRE='$idpadre'";
       $rows=$this->db->query($sql);  
        return $rows;
    }
  

    public function get_allSubvistas($idpadre,$codigo) 
	{
    
       	 $sql = "SELECT * FROM dg_vistas where VIS_P_PADRE='$idpadre'";
       	 $result=$this->db->query($sql);
             while($lista=$result->fetch_array()){                        
                 ?>
                        
                            <ul>
                            <li>
                              <a onclick="from2(<?php echo $codigo?>,<?php echo $lista[0]?>,'view','../Vistas/vistas/ajaxAgregar.php')"><?php echo $lista[1];?></a>
                              </li>
                              <?php   $this->get_allSubvistas($lista[0],$codigo);?>
                            
                                
                              
                            </ul>
                        
                      
               
              
      <?php 
        }
    }
  
}

?>
