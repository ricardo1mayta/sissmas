<?php

class detOrdenes {

private $db;

public function __construct() 
{
        
         $this->db = new Conexion();
       
}
   public function get_savedetorden($idpro,$can,$pc,$pv,$idord,$idus) 
    {
        $sql = "call sp_agrega_detorden('$idpro','$can','$pc','$pv','$idord','$idus')";
       
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
      
    } 
     public function get_editacandetorden($idord,$iddetor,$can) 
    {
        $sql = "call sp_updatecandetorden('$idord','$iddetor','$can')";
       
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
      
    } 
     public function get_eliminadetorden($idord,$iddetor) 
    {
        $sql = "call sp_deletedetorden('$idord','$iddetor')";
       
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
      
    } 
     public function get_editapredetorden($idord,$iddetor,$pre) 
    {
        $sql = "call sp_editapredetord('$idord','$iddetor','$pre')";
       
       $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
    
        return $result;
      
    } 
   
public function get_alliddetordenes($idord) 
{
        $sql = "SELECT * FROM sm_detordenes do inner join sm_productos p on do.PRO_C_CODIGO=p.PRO_C_CODIGO WHERE do.ORD_C_CODIGO='$idord' AND DTL_E_ESTADO=1 ";
        
       $rows=$this->db->query($sql);  
          
        return $rows;
      
    }

    public function get_caniddetor($idord,$iddetor) 
{
        $sql = "SELECT * FROM sm_detordenes do WHERE do.ORD_C_CODIGO='$idord' and do.DTL_C_CODIGO='$iddetor' AND DTL_E_ESTADO=1";
        
       $rows=$this->db->query($sql);  
         $result=$rows->fetch_array();
    
        return $result;
      
    }
}
?>