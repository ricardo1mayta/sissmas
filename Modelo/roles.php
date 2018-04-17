<?php



class Roles{

private $db;

public function __construct() 
{
        $this->db = new Conexion();
        
}
	
    
   
    public function get_allRoles() {
        $result=$this->db->query("SELECT * FROM dg_roles");
       
        return $result;

    }
   

}

?>
