<?php

class User {

private $db;

public function __construct() 
{
        
         $this->db = new Conexion();
       
}
	
   
public function register_user($nombre,$apell,$correo,$pass,$sede,$img) 
{
      
		
		$sql = "call sp_insertar_usuario('$nombre','$apell','$correo','$pass','$sede','$img');";
        
       $rows=$this->db->query($sql);  
		$result=$rows->fetch_array();
	
		return $result;
		
		
    }

   public function check_login($emailusername, $password) 
	{  
       
        $password = ($password);
		
       $sql="SELECT * from dg_user U INNER JOIN dg_sedes S ON U.SED_C_CODIGO=S.SED_C_CODIGO WHERE U.US_C_CORREO = '$emailusername' and U.US_P_PASSWORD = '$password' AND S.SED_E_ESTADO=1;";

        $rows=$this->db->query($sql);      
		$no_rows =$this->db->rows($rows);
        if ($no_rows == 1) 
		{
     
            $_SESSION['login'] = true;
            $_SESSION['usuario'] = $rows->fetch_array();

            
            return $no_rows;
        }
        else
		{
		    return $no_rows;
		}
    }

    public function get_fullname($uid) 
	{
        $result = mysql_query("SELECT name FROM users WHERE uid = $uid");
        $user_data = mysql_fetch_array($result);
        echo $user_data['name'];
    }
  

    public function get_session() 
	{
	    
        return $_SESSION['login'];
    }

    public function user_logout() {
        
        $_SESSION['login'] = FALSE;
        session_destroy();
    }
    public function lista_usuarios() 
    {  
              $sql="SELECT * from dg_user U INNER JOIN dg_sedes S ON U.SED_C_CODIGO=S.SED_C_CODIGO where S.SED_E_ESTADO=1 and U.US_E_ESTADO>0;";   
            $result=$this->db->query($sql);   
            
            return $result;
            
          
    }
     public function delete_usuario($id) 
    {  
              $sql="CALL sp_delete_usuario('$id');";   
            $rows=$this->db->query($sql);   
            $result=$rows->fetch_array();
            return $result;
            
          
    }
    public function update_usuario($id,$nombre,$apell,$correo,$pass,$sede,$img) 
    {  
              $sql="CALL sp_modificar_usuario('$id','$nombre','$apell','$correo','$pass','$sede','$img');";   
            $rows=$this->db->query($sql);   
            $result=$rows->fetch_array();
            return $result;
            
          
    }





    public function lista_usuariosprensa($rol1,$rol2) 
    {  
              $sql="SELECT distinct u.US_C_CODIGO,u.US_D_NOMBRE,u.US_D_APELL FROM dg_permisos P inner join dg_user u on u.US_C_CODIGO=P.US_C_CODIGO where RO_C_CODIGO=".$rol1." OR RO_C_CODIGO=".$rol2;   
            $result = mysql_query($sql);
            
            return $result;
            
          
    }
   

}

?>
