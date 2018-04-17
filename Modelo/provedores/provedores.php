<?php 
class Provedores {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	}
 public function save_provedor($nombre,$ruc,$direccion,$telefono,$correo,$us,$sed) 
    {
         $sql = "call  spp_save_provedor('$nombre','$ruc','$direccion','$telefono','$correo','$us','$sed');";
         $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;

    }
public function get_provedores($txt,$sed) 
    {
         $sql = "SELECT PV_C_CODIGO,PV_D_NOMBRES,PV_C_DOC,PV_D_DIRECCION FROM sm_provedores WHERE SED_C_CODIGO=spadre('$sed') AND PV_E_ESTADO>0 AND PV_D_NOMBRES LIKE '".$txt."%' LIMIT 10;";
         $rows=$this->db->query($sql);  
        return $rows;

    }
    public function get_allprovedores($sed) 
    {
         $sql = "SELECT * FROM  `sm_provedores`  WHERE SED_C_CODIGO=spadre('$sed') AND PV_E_ESTADO>0";
         $rows=$this->db->query($sql);  
        return $rows;

    }
public function update_provedor($nombre,$ruc,$direccion,$telefono,$correo,$us,$id){
	$sql = "call  spp_update_provedor('$nombre','$ruc','$direccion','$telefono','$correo','$us','$id');";

		$rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
}
public function delete_provedor($us,$id){
	$sql = "call  spp_delete_provedor('$id','$us');";

		$rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
}

   
}
?>