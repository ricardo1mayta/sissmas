
<?php 
class Cliente {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
public function save_cliente($ruc,$nombre,$apellidos ,$direccion,$telefono,$correo,$sed,$us) 
{
             
         $sql = "CALL spc_save_cliente('$ruc','$nombre','$apellidos','$direccion','$telefono','$correo','$sed','$us');";
       
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
        
        
    }
  
public function update_cliente($nombre,$ape,$ruc,$direc,$tele,$corr,$us,$id) {
      
       
        $sql = "CALL spc_update_cliente('$ruc','$nombre','$ape','$direc','$tele','$corr','$us','$id');";
        
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
        
        
    }
public function delete_cliente($us,$id) {
      
       
        $sql = "CALL spc_delete_cliente('$id','$us');";
        
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
        
        
    }
    

    public function get_allclientes($sed) 
    {
        $sql = "SELECT `CLI_C_CODIGO`, `CLI_D_NOMBRE`,`CLI_D_APELLIDOS`, `CLI_D_DOC`, `CLI_D_DIRECCION`, `CLI_T_TELEFONO`, `CLI_D_CORREO` FROM `sm_cliente` WHERE `SED_C_CODIGO`=spadre('$sed') and  `CLI_E_ESTADO` > 0;";
       $rows=$this->db->query($sql);  
        return $rows;
    }

      public function get_nomclientes($idus,$nom) 
    {
        $sql = "SELECT * FROM  `sm_cliente`  WHERE `AUD_C_USUCREA`='$idus' and CLI_D_NOMBRE LIKE '$nom%'";
       $rows=$this->db->query($sql);  
        return $rows;
    }

      public function get_idclientes($idus,$idcli) 
    {
        $sql = "SELECT * FROM  `sm_cliente`  WHERE `AUD_C_USUCREA`='$idus' and CLI_C_CODIGO='$idcli'";
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
    }


public function get_clientes($txt,$sed) 
    {
         $sql = "SELECT `CLI_C_CODIGO`,concat(`CLI_D_NOMBRE`,' ',`CLI_D_APELLIDOS`) as NOMBRE ,`CLI_D_DIRECCION`,`CLI_D_DOC` FROM `sm_cliente` WHERE `SED_C_CODIGO`=spadre('$sed') and concat(`CLI_D_NOMBRE`,' ',`CLI_D_APELLIDOS`) LIKE '".$txt."%' LIMIT 10;";
         $rows=$this->db->query($sql);  
        return $rows;

    }
}
 ?>