<?php

class Almacen {

	private $db;

	public function __construct() 
	{
	        
	         $this->db = new Conexion();
	       
	}
	public function despachar($idven,$us) 
    {
       $sql = "call spt_despachar_almacen('$idven','$us');";
         $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
        return $result;

    }
    public function recepcionar($idven,$us) 
    {
       $sql = "call spt_despachar_almacen('$idven','$us');";
         $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
        return $result;

    }
	public function get_series($iddped) 
    {
       $sql = "SELECT CONCAT(DES_C_SERIE) SERIE FROM sm_despachoproductos WHERE DPED_C_CODIGO='$iddped';";
        
         $rows=$this->db->query($sql);  
         
         return $rows;

    }
    public function get_seriesc($iddped) 
    {
       $sql = "SELECT CONCAT(RES_C_SERIE) SERIE FROM sm_recepcionproductos WHERE DCOM_C_CODIGO='$iddped';";
        
         $rows=$this->db->query($sql);  
         
         return $rows;

    }



    public function agregaserie($iddped,$idped,$us,$serie) 
    {
       	$sql = "call sta_despachoproductos('$iddped','$idped','$us','$serie')";
        $rows=$this->db->query($sql);  
     	$result=$rows->fetch_array();
     	return $result;

    }
      public function agregaserierecepcion($iddcom,$idcom,$us,$serie) 
    {
         $sql = "call sta_recepcionproductos('$iddcom','$idcom','$us','$serie')";
        $rows=$this->db->query($sql);  
        $result=$rows->fetch_array();
        return $result;

    }
}