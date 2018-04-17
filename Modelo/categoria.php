<?php

class Categoria {

private $db;

public function __construct() 
{
        
         $this->db = new Conexion();
       
}
	
   
public function register($nombre,$apell,$correo,$pass,$sede,$img) 
{
      
		
		$sql = "call sp_insertar_usuario('$nombre','$apell','$correo','$pass','$sede','$img');";
        
       $rows=$this->db->query($sql);  
		$result=$rows->fetch_array();
	
		return $result;
		
		
    }

  

    public function get_allcategoria($idus) 
	{
        $sql = "SELECT * FROM `sm_categoria` WHERE  AUD_U_USARIOCREA='$idus' ";
       $rows=$this->db->query($sql);  
        return $rows;
    }
  
}