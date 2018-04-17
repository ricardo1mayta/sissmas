

DELIMITER $$
--
-- Procedimientos
--
CREATE  PROCEDURE `spa_save_compra` (IN `us` INT, IN `pv` INT, IN `tipdoc` INT, IN `sed` INT, IN `numdoc` VARCHAR(20), IN `total` DECIMAL(8,2), IN `tippago` INT)  NO SQL
BEGIN

INSERT into sm_compra(
    US_C_CODIGO,
    PV_C_CODIGO,
    SED_C_CODIGO,
    C_N_NUMDOC,
    T_C_CODIGO,
    C_N_TOTAL,
    AUD_F_FECHAINSERCION,
    AUD_U_USARIOCREA) 
    VALUES(
us,pv,sed,numdoc,tipdoc,total,now(),us);
SELECT 'ok' as sms;

END$$

CREATE  PROCEDURE `sp_agrega_detorden` (IN `idpro` INT, IN `can` DECIMAL(8,2), IN `pc` DECIMAL(8,2), IN `pv` DECIMAL(8,2), IN `idord` INT, IN `idus` INT)  NO SQL
BEGIN
    
    IF EXISTS ( SELECT * FROM sm_productos WHERE PRO_C_CODIGO=idpro AND PRO_N_CANTIDAD>=can) then
    
        IF NOT EXISTS (SELECT * FROM sm_detordenes where PRO_C_CODIGO=idpro and ORD_C_CODIGO=idord) then
            INSERT INTO `sm_detordenes`(`DTL_C_CODIGO`, `PRO_C_CODIGO`, `ORD_C_CODIGO`, `DTL_N_CANTIDAD`, 
                                        `DTL_N_PRECOMPRA`, `DTL_N_PRECIOVENTA`, `DTL_N_IMPORTE`, `DTL_N_DESCUENTO`, DTL_E_ESTADO) 
            VALUES (NULL,idpro,idord,can,pc,pv,pv*can,0,'1');
            select 'ok' as sms;
        ELSE
            
            UPDATE sm_detordenes SET DTL_N_CANTIDAD=DTL_N_CANTIDAD+can,DTL_N_IMPORTE=DTL_N_CANTIDAD*DTL_N_PRECIOVENTA 
            where PRO_C_CODIGO=idpro and ORD_C_CODIGO=idord;
        
            select 'ok' as sms;
        END IF;

		UPDATE sm_productos SET PRO_N_CANTIDAD=PRO_N_CANTIDAD-can where PRO_C_CODIGO=idpro;

    ELSE
        SELECT 'cantidad insuficiente' as sms;
    END IF;

END$$

CREATE  PROCEDURE `sp_agrega_vista` (IN `id` INT, IN `idus` INT)  NO SQL
BEGIN
  
	DECLARE estado int;	

    IF NOT EXISTS (select * from dg_permisos where VIS_C_CODIGO=id and US_C_CODIGO=idus) THEN
      
    INSERT INTO dg_permisos (US_C_CODIGO,RO_C_CODIGO,VIS_C_CODIGO,PER_E_ESTADO) VALUES(idus,1,id,1);
      SELECT 'ok' as sms;
      ELSE
	SET estado=(SELECT PER_E_ESTADO FROM dg_permisos WHERE US_C_CODIGO=idus and VIS_C_CODIGO=id);
        IF(estado=0) THEN
        
        UPDATE dg_permisos SET PER_E_ESTADO=1 WHERE US_C_CODIGO=idus and VIS_C_CODIGO=id;
            SELECT 'se activo!' as sms;
        ELSE
            UPDATE dg_permisos SET PER_E_ESTADO=0 WHERE US_C_CODIGO=idus and VIS_C_CODIGO=id;
            SELECT 'desactivado!' as sms;
		END IF;
    END IF;
END$$

CREATE  PROCEDURE `SP_BALANCE` (`fecha1` DATE, `monto` DECIMAL(8,2))  BEGIN
 
	DECLARE MONTO_ANT DECIMAL(8,2);
	IF NOT EXISTS ( SELECT * FROM sm_capitaldia WHERE CAP_F_FECHA=fecha1)
	 THEN
			
			SET MONTO_ANT=(SELECT IFNULL(CAP_N_MONTO,0) FROM sm_capitaldia WHERE CAP_F_FECHA=DATE_SUB( fecha1, INTERVAL 1 DAY ));
			SET MONTO_ANT=MONTO_ANT+monto;
			INSERT INTO sm_capitaldia(CAP_C_CODIGO,CAP_N_MONTO,CAP_F_FECHA) 
			VALUES (null,monto,fecha1);
			
			
	ELSE
			UPDATE sm_capitaldia SET CAP_N_MONTO=CAP_N_MONTO+monto WHERE CAP_F_FECHA=fecha1 ;
	END IF;
	

 END$$

CREATE  PROCEDURE `SP_CAJA` (`fecha` DATE)  BEGIN
 DECLARE UTILIDAD DECIMAL(8,2);
 DECLARE CAJA DECIMAL(8,2);
 DECLARE STOCK DECIMAL(8,2);
 DECLARE STOCK_P DECIMAL(8,2);
 

SET UTILIDAD=( SELECT UTI_N_MONTO FROM sm_utilidad WHERE UTI_F_FECHA=fecha);
  SET CAJA=(SELECT CAP_N_MONTO FROM sm_capitaldia WHERE CAP_F_FECHA=fecha);
 	SET STOCK=(SELECT SUM(PRO_N_PRECIOCOMPRA*PRO_N_CANTIDAD) FROM sm_productos WHERE PRO_E_ESTADO>=1 );
	SET STOCK_P=(SELECT SUM(DP.DTL_N_CANTIDAD*DP.DTL_N_PRECOMPRA) FROM sm_pedidos P 
		INNER JOIN sm_detpedidos DP ON DP.PED_C_CODIGO=P.PED_C_CODIGO WHERE P.PED_E_ESTADO=1 AND DP.DTL_E_ESTADO=1);
		
SELECT UTILIDAD ,CAJA,STOCK,STOCK_P;
 END$$

CREATE  PROCEDURE `sp_cliente_orden` (IN `idcli` INT, IN `idord` INT)  NO SQL
BEGIN

	UPDATE `sm_ordenes` SET `CLI_C_CODIGO`=idcli WHERE ORD_C_CODIGO=idord ;

	select 'ok' as sms;

END$$

CREATE  PROCEDURE `SP_COM` (`id_pedido` INT, `fecha` DATE)  BEGIN
 DECLARE UTILIDAD DECIMAL(8,2);
 DECLARE FACTOR DECIMAL(8,2);
 SET FACTOR=-1;
SET UTILIDAD=( SELECT C_N_TOTAL FROM sm_compra WHERE C_C_CODIGO=id_pedido AND C_E_ESTADO>0);
  SET UTILIDAD=UTILIDAD*FACTOR;
 CALL SP_BALANCE(fecha,UTILIDAD);	

 END$$

CREATE  PROCEDURE `sp_deletedetorden` (IN `idord` INT, IN `iddetor` INT)  NO SQL
begin
    DECLARE can int;
	DECLARE idpro int;
	DECLARE sms text;

    set can=(SELECT  DTL_N_CANTIDAD FROM sm_detordenes WHERE  DTL_C_CODIGO=iddetor and ORD_C_CODIGO=idord);
    set idpro=(SELECT PRO_C_CODIGO FROM sm_detordenes WHERE  DTL_C_CODIGO=iddetor and ORD_C_CODIGO=idord);
   
	UPDATE sm_productos SET  PRO_N_CANTIDAD=PRO_N_CANTIDAD+can where PRO_C_CODIGO=idpro;
    UPDATE sm_detordenes SET DTL_N_CANTIDAD=0, DTL_E_ESTADO=0 WHERE DTL_C_CODIGO=iddetor and ORD_C_CODIGO=idord;
    
	set sms='<label><font color=#008000>ok</font>';
	select  idpro;
end$$

CREATE  PROCEDURE `sp_deleteorden` (IN `idord` INT, IN `idus` INT)  NO SQL
begin
   
	DECLARE sms text;

	


IF EXISTS(SELECT * FROM sm_ordenes WHERE ORD_C_CODIGO=idord AND AUD_C_USUCREA=idus and ORD_E_ESTADO=1) then

        UPDATE sm_productos p, sm_detordenes do SET  p.PRO_N_CANTIDAD=p.PRO_N_CANTIDAD+do.DTL_N_CANTIDAD where p.PRO_C_CODIGO=do.PRO_C_CODIGO and do.ORD_C_CODIGO=idord ;
        
    
        UPDATE sm_ordenes SET ORD_E_ESTADO=0 WHERE ORD_C_CODIGO=idord AND AUD_C_USUCREA=idus ;

      set sms='<small class="label label-success"><i class="fa fa-clock-o"></i> Ok</small>';
	
else
	set sms='<small class="label label-warning"><i class="fa fa-clock-o"></i>Ya fue eliminado</small>';
end if;
	

select  sms;
end$$

CREATE  PROCEDURE `sp_delete_usuario` (IN `id` INT)  NO SQL
BEGIN
  
    IF EXISTS (select * from dg_user where US_C_CODIGO=id) THEN
      
    UPDATE dg_user SET US_E_ESTADO=0 WHERE US_C_CODIGO=id;
      SELECT 'ok' as sms;
      ELSE
        SELECT 'ya no existe en la base de datos!' as sms;
    END IF;
END$$

CREATE  PROCEDURE `sp_editapredetord` (IN `idord` INT, IN `iddetor` INT, IN `pre` DECIMAL(8,2))  NO SQL
begin 
 UPDATE `sm_detordenes` SET `DTL_N_PRECIOVENTA`=pre,`DTL_N_IMPORTE`=`DTL_N_CANTIDAD`*DTL_N_PRECIOVENTA WHERE DTL_C_CODIGO=iddetor and ORD_C_CODIGO=idord;
            select '<font color=#008000>ok</font>' as sms;

end$$

CREATE  PROCEDURE `sp_insertar_usuario` (IN `nom` VARCHAR(45), IN `apell` VARCHAR(45), IN `correo` VARCHAR(45), IN `pas` VARCHAR(45), IN `sede` VARCHAR(30), IN `img` VARCHAR(40))  BEGIN
  
    IF NOT EXISTS (select * from dg_user where US_C_CORREO=correo) THEN
      
     INSERT INTO dg_user (US_C_CODIGO,US_C_CORREO,US_P_PASSWORD,US_D_NOMBRE,US_D_APELL,US_F_FECHAINGRESO,US_E_ESTADO,US_I_IMAGEN,SED_C_CODIGO) 
     VALUES(NULL,correo,pas,UPPER(nom),UPPER(apell),now(),1,img,sede);
      SELECT 'ok' as sms;
      ELSE
        SELECT 'ya existe en la base de datos!' as sms;
    END IF;

END$$

CREATE  PROCEDURE `sp_modificar_usuario` (IN `id` INT, IN `nom` VARCHAR(45), IN `apell` VARCHAR(45), IN `correo` VARCHAR(45), IN `pas` VARCHAR(45), IN `sede` VARCHAR(30), IN `img` VARCHAR(40))  BEGIN
  
    
     UPDATE dg_user SET US_C_CORREO=correo,US_P_PASSWORD=pas ,US_D_NOMBRE=UPPER(nom) ,US_D_APELL=UPPER(apell), US_I_IMAGEN=img, SED_C_CODIGO=sede 			where US_C_CODIGO=id;
      SELECT 'ok' as sms;
     

END$$

CREATE  PROCEDURE `SP_NUEVA_CUENTA` (`id_prov` INT, `fecha` DATETIME)  BEGIN

	DECLARE TOTAL DECIMAL(8,2);
	DECLARE ID_CC INT;
	SET TOTAL=(SELECT SUM(C.C_N_TOTAL) FROM sm_compra C 
	INNER JOIN sm_provedores P ON P.PV_C_CODIGO=C.PV_C_CODIGO
	WHERE C_E_ESTADO=1 AND C.PV_C_CODIGO=id_prov);
	IF NOT EXISTS ( SELECT * FROM sm_cuentasCompras CC WHERE CC.PV_C_CODIGO = id_prov and CC.CC_E_ESTADO=1)
	 THEN
			INSERT INTO sm_cuentasCompras(CC_C_CODIGO,PV_C_CODIGO,CC_N_TOTAL,CC_N_CANCELA,CC_F_FECHA,CC_E_ESTADO) 
			VALUES (null,id_prov,TOTAL,0,fecha,1);
			
			
	ELSE
			UPDATE sm_cuentasCompras SET CC_N_TOTAL=TOTAL WHERE PV_C_CODIGO=id_prov and CC_E_ESTADO=1;
	END IF;
	SET ID_CC=(SELECT CC_C_CODIGO FROM sm_cuentasCompras  WHERE PV_C_CODIGO = id_prov and CC_E_ESTADO=1);
	SELECT ID_CC;

 END$$

CREATE  PROCEDURE `SP_NUEVA_C_VENTA` (`id_cli` INT, `fecha` DATETIME)  BEGIN

	DECLARE TOTAL DECIMAL(8,2);
	DECLARE ID_CC INT;
	SET TOTAL=(SELECT SUM(VEN_N_TOTAL) FROM sm_ventas V 
	INNER JOIN sm_cliente C ON C.CLI_C_CODIGO=V.CLI_C_CODIGO
	WHERE VEN_E_ESTADO=1 AND V.CLI_C_CODIGO=id_cli);
	IF NOT EXISTS ( SELECT * FROM sm_cuentasVentas WHERE CLI_C_CODIGO = id_cli and CV_E_ESTADO=1)
	 THEN
			INSERT INTO sm_cuentasVentas(CV_C_CODIGO,CLI_C_CODIGO,CV_N_TOTAL,CV_N_CANCELA,CV_F_FECHA,CV_E_ESTADO)
			VALUES (null,id_cli,TOTAL,0,fecha,1);
			
			
	ELSE
			UPDATE sm_cuentasVentas SET CV_N_TOTAL=TOTAL WHERE CLI_C_CODIGO=id_cli and CV_E_ESTADO=1;
	END IF;
	SET ID_CC=(SELECT CV_C_CODIGO FROM sm_cuentasVentas  WHERE CLI_C_CODIGO = id_cli and CV_E_ESTADO=1);
	SELECT ID_CC;

 END$$

CREATE  PROCEDURE `sp_nueva_orden` (IN `idus` INT)  NO SQL
BEGIN

	INSERT INTO `sm_ordenes`(`ORD_C_CODIGO`,CLI_C_CODIGO, `ORD_E_ESTADO`,
                 `AUD_C_USUCREA`, `AUD_F_FECHACREA`)
	VALUES(NULL,1,1,idus,now());

	SELECT MAX(ORD_C_CODIGO) as ORD_C_CODIGO from sm_ordenes;

END$$

CREATE  PROCEDURE `SP_NUEVO_PAGO` (`id_cuen` INT, `id_prov` INT, `abo` DECIMAL(8,2), `fecha` DATETIME)  BEGIN

	DECLARE TOTAL DECIMAL(8,2);
	DECLARE ABONO DECIMAL(8,2);
	
	SET TOTAL=(SELECT SUM(C.C_N_TOTAL) FROM sm_compra C 
	INNER JOIN sm_provedores P ON P.PV_C_CODIGO=C.PV_C_CODIGO
	WHERE C_E_ESTADO=1 AND C.PV_C_CODIGO=id_prov);
	
	SET ABONO=(SELECT IFNULL(SUM(PC_N_ABONA),0) FROM sm_pagosC WHERE PV_C_CODIGO=id_prov AND CC_C_CODIGO=id_cuen );
	SET ABONO=ABONO+abo;

	IF(TOTAL<=ABONO)
	 THEN
			INSERT INTO sm_pagosC(PC_C_CODIGO,PV_C_CODIGO,CC_C_CODIGO,PC_N_ABONA,PC_F_FECHA)
			VALUES (null,id_prov,id_cuen,abo,fecha);
			UPDATE sm_cuentasCompras SET CC_N_TOTAL =TOTAL,CC_N_CANCELA=TOTAL,CC_E_ESTADO=2 WHERE CC_C_CODIGO=id_cuen;
			UPDATE sm_compra SET C_C_CANCELADO=C_N_TOTAL ,C_E_ESTADO=2 WHERE C_E_ESTADO=1 AND PV_C_CODIGO=id_prov;
			
			
			
	ELSE
		INSERT INTO sm_pagosC(PC_C_CODIGO,PV_C_CODIGO,CC_C_CODIGO,PC_N_ABONA,PC_F_FECHA)
			VALUES (null,id_prov,id_cuen,abo,fecha);
			UPDATE sm_cuentasCompras SET CC_N_CANCELA=ABONO WHERE CC_C_CODIGO=id_cuen;
	END IF;
	

 END$$

CREATE  PROCEDURE `SP_NUEVO_PAGO_V` (`id_cuen` INT, `id_cli` INT, `abo` DECIMAL(8,2), `fecha` DATETIME)  BEGIN

	DECLARE TOTAL DECIMAL(8,2);
	DECLARE ABONO DECIMAL(8,2);
	
	SET TOTAL=(SELECT SUM(VEN_N_TOTAL) FROM sm_ventas V 
	INNER JOIN sm_cliente C ON C.CLI_C_CODIGO=V.CLI_C_CODIGO
	WHERE VEN_E_ESTADO=1 AND V.CLI_C_CODIGO=id_cli);
	
	SET ABONO=(SELECT IFNULL(SUM(VV_N_ABONA),0) FROM sm_pagosV WHERE CLI_C_CODIGO=id_cli AND CV_C_CODIGO=id_cuen );
	SET ABONO=ABONO+abo;

	IF(TOTAL<=ABONO)
	 THEN
			INSERT INTO sm_pagosV(VV_C_CODIGO,CV_C_CODIGO,CLI_C_CODIGO,VV_N_ABONA,VV_F_FECHA)
			VALUES (null,id_cuen,id_cli,abo,fecha);
			UPDATE sm_cuentasVentas SET CV_N_TOTAL=TOTAL,CV_N_CANCELA=TOTAL,CV_E_ESTADO=2 WHERE CV_C_CODIGO=id_cuen;
			
			UPDATE sm_ventas SET VEN_N_CANCELA=VEN_N_TOTAL ,VEN_E_ESTADO=2 WHERE VEN_E_ESTADO=1 AND CLI_C_CODIGO=id_cli;
			
			
			
	ELSE
		INSERT INTO sm_pagosV(VV_C_CODIGO,CV_C_CODIGO,CLI_C_CODIGO,VV_N_ABONA,VV_F_FECHA)
			VALUES (null,id_cuen,id_cli,abo,fecha);
			UPDATE sm_cuentasVentas SET CV_N_CANCELA=ABONO WHERE CV_C_CODIGO=id_cuen;
	END IF;
	

 END$$

CREATE  PROCEDURE `SP_RESUMEN` (`fecha` DATE)  BEGIN

	DECLARE VENTAS DECIMAL(8,2);
	DECLARE COMPRAS DECIMAL(8,2);
	DECLARE STOCK DECIMAL(8,2);
	DECLARE V_COBRAR DECIMAL(8,2);
	DECLARE C_PAGAR DECIMAL(8,2);
	DECLARE GASTOS_ADM DECIMAL(8,2);
	DECLARE V_UTILIDAD DECIMAL(8,2);
	
	
	SET VENTAS=(SELECT SUM(VEN_N_TOTAL) FROM sm_ventas V 	WHERE VEN_E_ESTADO>=1 AND DATE(`VEN_F_FECHA`)=fecha );
	SET COMPRAS=(SELECT SUM(`C_N_TOTAL`) FROM `sm_compra` WHERE `C_E_ESTADO`>=1 AND DATE(`C_F_FECHA`)=fecha );
	SET STOCK=(SELECT SUM(`PRO_N_PRECIOCOMPRA`*`PRO_N_CANTIDAD`) FROM `sm_productos` WHERE `PRO_E_ESTADO`>=1 );
	SET V_COBRAR=(SELECT SUM(  `VEN_N_TOTAL` -  `VEN_N_CANCELA` ) FROM  `sm_ventas` WHERE  `VEN_E_ESTADO` =1);
	SET C_PAGAR=(SELECT SUM(`C_N_TOTAL`-`C_C_CANCELADO`) FROM `sm_compra` WHERE `C_E_ESTADO`=1 );
	SET GASTOS_ADM=(SELECT SUM(`EIG_N_MONTO`) FROM `sm_tbingegre` WHERE `EIG_E_ESTADO`=1 AND DATE(`EIG_F_FECHA`)=fecha);
	SET V_UTILIDAD=(SELECT SUM(DV.DVE_N_CANTIDAD*DV.DVE_N_PRECIO)-SUM(P.PRO_N_PRECIOCOMPRA*DV.DVE_N_CANTIDAD) AS GANANCIA FROM sm_productos P
		RIGHT JOIN sm_dtventas DV  ON P.PRO_C_CODIGO=DV.PRO_C_CODIGO
		INNER JOIN sm_ventas V ON V.VEN_C_CODIGO =DV.VEN_C_CODIGO
		WHERE V.VEN_F_FECHA=fecha AND VEN_E_ESTADO>0 );
	SELECT VENTAS,COMPRAS,STOCK,V_COBRAR,C_PAGAR,GASTOS_ADM,V_UTILIDAD,
	V_UTILIDAD-GASTOS_ADM+STOCK,V_UTILIDAD-GASTOS_ADM+STOCK-C_PAGAR+V_COBRAR;
	

 END$$

CREATE  PROCEDURE `SP_RESUMEN_MES` (`fecha1` DATE, `fecha2` DATE)  BEGIN

	DECLARE VENTAS DECIMAL(8,2);
	DECLARE COMPRAS DECIMAL(8,2);
	DECLARE STOCK DECIMAL(8,2);
	DECLARE STOCK_P DECIMAL(8,2);
	DECLARE V_COBRAR DECIMAL(8,2);
	DECLARE C_PAGAR DECIMAL(8,2);
	DECLARE GASTOS_ADM DECIMAL(8,2);
	DECLARE V_UTILIDAD DECIMAL(8,2);
	
	
	SET VENTAS=(SELECT SUM(VEN_N_TOTAL) FROM sm_ventas V 	WHERE VEN_E_ESTADO>=1 AND DATE(`VEN_F_FECHA`)>=fecha1 AND DATE(`VEN_F_FECHA`)<=fecha2 );
	SET COMPRAS=(SELECT SUM(`C_N_TOTAL`) FROM `sm_compra` WHERE `C_E_ESTADO`>=1 AND DATE(`C_F_FECHA`)>=fecha1 AND DATE(`C_F_FECHA`)<=fecha2 );
	SET STOCK=(SELECT SUM(`PRO_N_PRECIOCOMPRA`*`PRO_N_CANTIDAD`) FROM `sm_productos` WHERE `PRO_E_ESTADO`>=1 );
	SET STOCK_P=(SELECT SUM(`DTL_N_CANTIDAD`*`DTL_N_PRECOMPRA`) FROM `sm_detpedidos` WHERE  `DTL_E_ESTADO`>=1 );
	SET V_COBRAR=(SELECT sum(`CV_N_TOTAL`-`CV_N_CANCELA`) FROM `sm_cuentasVentas` WHERE CV_E_ESTADO=1);
	SET C_PAGAR=(SELECT sum(`CC_N_TOTAL`-`CC_N_CANCELA`)FROM `sm_cuentasCompras` WHERE CC_E_ESTADO=1);
	SET GASTOS_ADM=(SELECT SUM(`EIG_N_MONTO`) FROM `sm_tbingegre` WHERE `EIG_E_ESTADO`=1 AND DATE(`EIG_F_FECHA`)>=fecha1 AND DATE(`EIG_F_FECHA`)<=fecha2);
	SET V_UTILIDAD=(SELECT SUM(DV.DVE_N_CANTIDAD*DV.DVE_N_PRECIO)-SUM(P.PRO_N_PRECIOCOMPRA*DV.DVE_N_CANTIDAD) AS GANANCIA FROM sm_productos P
		RIGHT JOIN sm_dtventas DV  ON P.PRO_C_CODIGO=DV.PRO_C_CODIGO
		INNER JOIN sm_ventas V ON V.VEN_C_CODIGO =DV.VEN_C_CODIGO
		WHERE V.VEN_F_FECHA>=fecha1 AND V.VEN_F_FECHA<=fecha2 AND VEN_E_ESTADO>0 );
	SELECT VENTAS,COMPRAS,STOCK,V_COBRAR,C_PAGAR,GASTOS_ADM,V_UTILIDAD,STOCK_P;
	

 END$$

CREATE  PROCEDURE `sp_save_producto` (IN `nombre` VARCHAR(60), IN `modelo` VARCHAR(60), IN `descripcion` TEXT, IN `cantidad` DECIMAL(8,2), IN `p_compra` DECIMAL(8,2), IN `p_venta` DECIMAL(8,2), IN `descuento` DECIMAL(8,2), IN `can_minima` DECIMAL(8,2), IN `img` VARCHAR(200), IN `categoria` INT, IN `marca` INT, IN `idus` INT)  NO SQL
BEGIN 

INSERT INTO `sm_productos`(PRO_C_CODIGO,`PRO_D_NOMBRE`, `PRO_D_MODELO`, `PRO_D_DESCRIPCION`, 
                           `CAT_C_CODIGO`, `MAR_C_CODIGO`,PV_C_CODIGO,`PRO_I_IMAGEN`, `PRO_N_CANTIDAD`,
                           `PRO_N_PRECIOCOMPRA`, `PRO_N_PRECIOVENTA`, `PRO_N_DESCUENTO`, `PRO_N_MINVENTA`,
                           `AUD_F_FECHAINSERCION`, `AUD_U_USARIOCREA`,`PRO_E_ESTADO`) 
VALUES (NULL,nombre,modelo,descripcion,categoria,marca,1,img,cantidad,p_compra, p_venta,descuento,can_minima,now(),idus,1);

select 'ok' as sms;

END$$

CREATE  PROCEDURE `sp_updatecandetorden` (IN `idord` INT, IN `iddetor` INT, IN `cant` DECIMAL(8,2))  NO SQL
begin

	DECLARE can int;
	DECLARE idpro int;
	DECLARE sms text;

	set idpro=(SELECT PRO_C_CODIGO FROM sm_detordenes WHERE  DTL_C_CODIGO=iddetor and ORD_C_CODIGO=idord);


IF EXISTS(SELECT * FROM `sm_productos` WHERE PRO_C_CODIGO=idpro and `PRO_N_CANTIDAD`>=cant) then

    set can=(SELECT  DTL_N_CANTIDAD FROM sm_detordenes WHERE  DTL_C_CODIGO=iddetor and ORD_C_CODIGO=idord);
   
   if(cant>0)then
    
        UPDATE sm_productos SET  PRO_N_CANTIDAD=PRO_N_CANTIDAD+can-cant where PRO_C_CODIGO=idpro;
        
    
        UPDATE `sm_detordenes` SET DTL_N_CANTIDAD=cant,`DTL_N_IMPORTE`=`DTL_N_CANTIDAD`*DTL_N_PRECIOVENTA WHERE DTL_C_CODIGO=iddetor and ORD_C_CODIGO=idord;
      set sms='<small class="label label-success"><i class="fa fa-clock-o"></i> Ok</small>';
	end if; 
else
	set sms='<small class="label label-warning"><i class="fa fa-clock-o"></i>Cantidad Isuficiente</small>';
end if;
	

select  sms;
end$$

CREATE  PROCEDURE `SP_UTILIDAD` (`id_pedido` INT, `fecha` DATE)  BEGIN
	 DECLARE UTILIDAD DECIMAL(8,2);
	SET UTILIDAD=( SELECT SUM(DV.DVE_N_CANTIDAD*DV.DVE_N_PRECIO)-SUM(P.PRO_N_PRECIOCOMPRA*DV.DVE_N_CANTIDAD) AS GANANCIA
	 FROM sm_productos P
	RIGHT JOIN sm_dtventas DV  ON P.PRO_C_CODIGO=DV.PRO_C_CODIGO
	INNER JOIN sm_ventas V ON V.VEN_C_CODIGO =DV.VEN_C_CODIGO
	WHERE  V.VEN_C_CODIGO = id_pedido AND VEN_E_ESTADO>0);
  
 IF NOT EXISTS ( SELECT * FROM sm_utilidad WHERE UTI_F_FECHA=fecha)
	 THEN
			
			
			INSERT INTO sm_utilidad(UTI_C_CODIGO,UTI_N_MONTO,UTI_F_FECHA) 
			VALUES (null,UTILIDAD,fecha);
			
			
	ELSE
			UPDATE sm_utilidad SET UTI_N_MONTO=UTI_N_MONTO+UTILIDAD WHERE UTI_F_FECHA=fecha ;
	END IF;

 END$$

CREATE  PROCEDURE `SP_VEN` (`id_pedido` INT, `fecha` DATE)  BEGIN
 DECLARE UTILIDAD DECIMAL(8,2);
SET UTILIDAD=( SELECT VEN_N_TOTAL FROM sm_ventas WHERE VEN_C_CODIGO=id_pedido AND VEN_E_ESTADO>0);
  
 CALL SP_BALANCE(fecha,UTILIDAD);	

 END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dg_permisos`
--

CREATE TABLE `dg_permisos` (
  `PRM_C_CODIGO` int(11) NOT NULL,
  `US_C_CODIGO` int(11) NOT NULL,
  `RO_C_CODIGO` int(11) NOT NULL,
  `VIS_C_CODIGO` int(11) NOT NULL,
  `PER_E_ESTADO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `dg_permisos`
--

INSERT INTO `dg_permisos` (`PRM_C_CODIGO`, `US_C_CODIGO`, `RO_C_CODIGO`, `VIS_C_CODIGO`, `PER_E_ESTADO`) VALUES
(1, 1, 0, 1, 1),
(2, 1, 0, 2, 1),
(3, 1, 0, 2, 0),
(4, 3, 1, 1, 0),
(5, 1, 1, 3, 1),
(6, 1, 1, 4, 1),
(7, 1, 1, 5, 1),
(8, 1, 1, 6, 1),
(9, 2, 1, 3, 1),
(10, 2, 1, 4, 1),
(11, 2, 1, 5, 1),
(12, 2, 1, 6, 1),
(13, 2, 1, 8, 1),
(14, 2, 1, 7, 1),
(15, 2, 1, 9, 1),
(16, 2, 1, 10, 1),
(17, 2, 1, 11, 1),
(18, 2, 1, 12, 1),
(19, 2, 1, 13, 1),
(20, 1, 1, 12, 1),
(21, 1, 1, 13, 1),
(22, 1, 1, 7, 1),
(23, 1, 1, 8, 1),
(24, 1, 1, 9, 1),
(25, 1, 1, 10, 1),
(26, 1, 1, 11, 1),
(27, 1, 1, 14, 1),
(28, 1, 1, 15, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dg_roles`
--

CREATE TABLE `dg_roles` (
  `RO_C_CODIGO` int(11) NOT NULL,
  `RO_N_NOMBRE` varchar(45) CHARACTER SET utf32 COLLATE utf32_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `dg_roles`
--

INSERT INTO `dg_roles` (`RO_C_CODIGO`, `RO_N_NOMBRE`) VALUES
(1, 'admin');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dg_sedes`
--

CREATE TABLE `dg_sedes` (
  `SED_C_CODIGO` int(11) NOT NULL,
  `SED_D_NOMBRE` varchar(30) COLLATE utf8mb4_spanish_ci NOT NULL,
  `SED_E_ESTADO` int(11) NOT NULL,
  `SED_C_PADRE` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `dg_sedes`
--

INSERT INTO `dg_sedes` (`SED_C_CODIGO`, `SED_D_NOMBRE`, `SED_E_ESTADO`, `SED_C_PADRE`) VALUES
(1, 'DIGAMMA ', 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dg_user`
--

CREATE TABLE `dg_user` (
  `US_C_CODIGO` int(11) NOT NULL,
  `US_C_CORREO` varchar(45) COLLATE utf8mb4_spanish_ci NOT NULL,
  `US_P_PASSWORD` varchar(45) COLLATE utf8mb4_spanish_ci NOT NULL,
  `US_D_NOMBRE` varchar(45) COLLATE utf8mb4_spanish_ci NOT NULL,
  `US_D_APELL` varchar(45) COLLATE utf8mb4_spanish_ci NOT NULL,
  `US_F_FECHANACIMIENTO` date DEFAULT NULL,
  `US_F_FECHAINGRESO` date DEFAULT NULL,
  `US_E_ESTADO` int(11) NOT NULL DEFAULT '1',
  `US_F_FECHASALIDA` date DEFAULT NULL,
  `US_I_IMAGEN` varchar(40) COLLATE utf8mb4_spanish_ci NOT NULL DEFAULT 'NNa.png',
  `SED_C_CODIGO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `dg_user`
--

INSERT INTO `dg_user` (`US_C_CODIGO`, `US_C_CORREO`, `US_P_PASSWORD`, `US_D_NOMBRE`, `US_D_APELL`, `US_F_FECHANACIMIENTO`, `US_F_FECHAINGRESO`, `US_E_ESTADO`, `US_F_FECHASALIDA`, `US_I_IMAGEN`, `SED_C_CODIGO`) VALUES
(1, 'rmayta@digammaperu.com', 'rmayta', 'RICARDO', 'MAYTA', '0000-00-00', '2011-11-24', 1, '0000-00-00', 'ricardo.jpg', 1),
(2, 'gilmer@gmail.com', 'gilmer58', 'GILMER', 'HUAMAN ', NULL, '2016-07-31', 1, NULL, 'gilmelhuaman.jpg', 1),
(3, 'ds', 'fsa', 'RICARDO', 'DAS', NULL, '2016-07-31', 0, NULL, '1.1.jpg', 1),
(4, 'ds@fkd.com', 'sda', 'RICARDO', 'DS', NULL, '2016-07-31', 0, NULL, '91NtH6M1OmL._SL1500_.jpg', 1),
(5, 'sa@dh.com', 'dfsa', 'SA', 'SA', NULL, '2016-07-31', 0, NULL, '1_buscar.png', 1),
(6, 'mari@hmail.com', '1234s', 'MARITZA', 'SARAYASI', NULL, '2016-08-03', 1, NULL, '1_buscar.png', 1),
(7, 'dsd@sfd.vo', 'dsa', 'KELMES', 'SDS', NULL, '2016-08-06', 1, NULL, '1_buscar.png', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dg_vistas`
--

CREATE TABLE `dg_vistas` (
  `VIS_C_CODIGO` int(11) NOT NULL,
  `VIS_D_NOMBRE` varchar(45) CHARACTER SET utf32 COLLATE utf32_spanish_ci DEFAULT NULL,
  `VIS_L_ENLACE` varchar(500) CHARACTER SET utf32 COLLATE utf32_spanish_ci DEFAULT NULL,
  `VIS_P_PADRE` int(11) NOT NULL,
  `VIS_I_IMG` varchar(45) CHARACTER SET utf32 COLLATE utf32_spanish_ci DEFAULT NULL,
  `VIS_E_ESTADO` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `dg_vistas`
--

INSERT INTO `dg_vistas` (`VIS_C_CODIGO`, `VIS_D_NOMBRE`, `VIS_L_ENLACE`, `VIS_P_PADRE`, `VIS_I_IMG`, `VIS_E_ESTADO`) VALUES
(1, 'ADMIN', NULL, 0, ' fa fa-cog', 1),
(2, 'Administracion de Usuarios', 'adminUsuarios', 1, 'fa fa-users', 1),
(3, 'PRODUCTOS', NULL, 0, 'fa fa-medkit', 1),
(4, 'Registrar Productos', 'registrarProductos', 3, 'fa fa-medkit', 1),
(5, 'Listar Productos', 'listarProductos', 3, NULL, 1),
(6, 'CLIENTES', NULL, 0, 'fa fa-user-plus', 1),
(7, 'Listar Clientes', 'listarClientes', 6, NULL, 1),
(8, 'Nuevo Cliente', 'registrarClientes', 6, NULL, 1),
(9, 'PROVEDORES', NULL, 0, 'fa  fa-user', 1),
(10, 'Listar Provedores', 'listarProvedores', 9, NULL, 1),
(11, 'Nuevo Provedor', 'registrarProvedores', 9, NULL, 1),
(12, 'VENTAS', NULL, 0, 'fa fa-folder', 1),
(13, 'Nuevo Pedido', 'registrarPedidos', 12, 'fa fa-folder', 1),
(14, 'COMPRAS', NULL, 0, 'fa fa-folder', 1),
(15, 'Nueva Compra', 'registrarCompras', 14, 'fa fa-folder', 1);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `dg_vista_menu`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `dg_vista_menu` (
`PRM_C_CODIGO` int(11)
,`US_C_CODIGO` int(11)
,`VIS_C_CODIGO` int(11)
,`VIS_P_PADRE` int(11)
,`VIS_D_NOMBRE` varchar(45)
,`VIS_L_ENLACE` varchar(500)
,`VIS_I_IMG` varchar(45)
,`VIS_E_ESTADO` int(11)
,`PER_E_ESTADO` int(11)
);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_capitaldia`
--

CREATE TABLE `sm_capitaldia` (
  `CAP_C_CODIGO` int(11) NOT NULL,
  `CAP_N_MONTO` decimal(8,2) NOT NULL,
  `CAP_F_FECHA` date NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_categoria`
--

CREATE TABLE `sm_categoria` (
  `CAT_C_CODIGO` int(11) NOT NULL,
  `CAT_D_NOMBRE` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `AUD_F_FECHAINSERCION` date DEFAULT NULL,
  `AUD_U_USARIOCREA` int(11) DEFAULT NULL,
  `AUD_F_FECHAMODIFICACION` date DEFAULT NULL,
  `AUD_U_USARIOMOFICIA` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_categoria`
--

INSERT INTO `sm_categoria` (`CAT_C_CODIGO`, `CAT_D_NOMBRE`, `AUD_F_FECHAINSERCION`, `AUD_U_USARIOCREA`, `AUD_F_FECHAMODIFICACION`, `AUD_U_USARIOMOFICIA`) VALUES
(1, '	 CELULARES	', '2015-04-27', 2, NULL, NULL),
(2, '	 TABLETS	', '2015-04-27', 2, NULL, NULL),
(3, '	 ACCESORIOS	', '2015-04-27', 2, NULL, NULL),
(4, 'PC ESCRITORIO', '2015-05-15', 2, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_cliente`
--

CREATE TABLE `sm_cliente` (
  `CLI_C_CODIGO` int(11) NOT NULL,
  `CLI_D_NOMBRE` varchar(60) NOT NULL,
  `CLI_D_APELLIDOS` varchar(60) NOT NULL,
  `CLI_D_DOC` varchar(11) NOT NULL,
  `CLI_D_DIRECCION` text NOT NULL,
  `CLI_T_TELEFONO` text NOT NULL,
  `CLI_D_CORREO` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `CLI_E_ESTADO` int(11) NOT NULL,
  `SED_C_CODIGO` int(11) NOT NULL,
  `AUD_C_USUCREA` int(11) DEFAULT NULL,
  `AUD_F_FECHACREA` date DEFAULT NULL,
  `AUD_C_USUMOD` int(11) DEFAULT NULL,
  `AUD_F_FECHAMOD` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_cliente`
--

INSERT INTO `sm_cliente` (`CLI_C_CODIGO`, `CLI_D_NOMBRE`, `CLI_D_APELLIDOS`, `CLI_D_DOC`, `CLI_D_DIRECCION`, `CLI_T_TELEFONO`, `CLI_D_CORREO`, `CLI_E_ESTADO`, `SED_C_CODIGO`, `AUD_C_USUCREA`, `AUD_F_FECHACREA`, `AUD_C_USUMOD`, `AUD_F_FECHAMOD`) VALUES
(1, 'FALTA', 'FALTA AGREGREGAR', '000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(2, 'YINER', 'TOLEDO DONATO', '43631410', 'pichanaqui', '945259425', 'yinertd@gmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(3, 'REYES ', 'HUAMAN SAUCEDO', '46016635', 'av atahualpa 606', '998075999', 'ryess_15_25@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(4, 'MARCO', 'AZUCENA DELGADO', '10510306', 'Calle tres 2301 edificio 5 dpto 504 los parques del agustino', '979143708', 'marcoazucena@outlook.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(5, 'NOE ', 'VEGA CASTRO', '42636190', 'Jiron Manuel Pasos 1252 SJM', '940981717', 'noejorel@gmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(6, 'DANIEL', 'BRAVO ATRULLA', '01560377', 'mz c lote 2 urbanizacion san ignacio entre jr albiceas y jr magnoleas', '942860059', 'danielbravoastrulla@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(7, 'MARIANO', 'SILVA RAMOS', '47102288', 'Urb Rinconada 2Â° Etapa F-27', '944193699', 'newmagio_xx@yahoo.es', 1, 1, 2, '0000-00-00', NULL, NULL),
(8, 'LUIS', 'CABALLERO ', '46834820', 'LIMA MESA REDONDA', '944621519', 'luis@hotamil.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(9, 'GREGORIO', 'YAURI YAULILAHUA', '46834820', 'SAN MARTIN PANGOA', '989898987', 'GRE@HOTMAIL.COM', 1, 1, 2, '0000-00-00', NULL, NULL),
(10, 'CLIENTE', 'NUEVO ', '98989898', 'LIMA MESA REDONDA', '787878789', 'ventas@perucell.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(11, 'TENORIO', 'HUAMAN SAUCEDO', '46758888', 'CAJAMRCA CAMPAÃ‘AN', '886578568', 'TINU@HOTMAIL.COM', 1, 1, 2, '0000-00-00', NULL, NULL),
(12, 'LIZBET', 'SALAZAR VILLAR', '64647373', 'CELENDIN CAJAMRACA', '75858484888', 'LIS@HOTMMAIL.COM', 1, 1, 2, '0000-00-00', NULL, NULL),
(13, 'KELVIN', 'MAYTA CRUZADO', '76767678', 'CELENDIN CAJAMARCA', '688678887', 'KELVIN@HOTMAIL.COM', 1, 1, 2, '0000-00-00', NULL, NULL),
(14, 'TATIANA', 'CHACON  SALAZAR', '5788788887', 'CELENDIN CAJAMARCA', '768799887', 'ricmaybacilon@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(15, 'VICTOR ', 'LLOVERA ', '65747484', 'CAJAMRCA cajamarca', '758547589', 'victor@gmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(16, 'RICHARD', 'SICCHA SANCHES', '75845858', 'HFJKHFLKJDSFL', '8750384702570', 'ricardo1mayta@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(17, 'LIZ RENE', 'HUAMAN REYES', '4666526656', 'pichanaki pichanaki', '6585656522', 'ricardo@hotm.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(18, 'PILAR', 'MAMANI MEZA', '00000000', '', '', 'ricardo1mayta@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(19, 'WILDER', 'MEZA ', '00000000', '', '', 'ricmaybacilon@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(20, 'YORDAN', 'MELGAR ', '00000000', 'SATIPO', '', 'ricmaybacilon@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(21, 'FRANCISCO', 'MEZA ', '00000000', 'MEZA', '', 'ricardo1mayta@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(22, 'ELDA', 'BARRAHONA QUISPE', '46834820', 'CUTERVO PERU', '654521555', 'JAVIER@HOTMAIL.COM', 1, 1, 2, '0000-00-00', NULL, NULL),
(23, 'EUGENIA', ' Pari', '26454545', 'Jr. cuzco 520', '949787878', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(24, 'susana', 'castrejon jaen ', '00000000', 'jr cajamarca ', '995253689', 'susana@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(25, 'TONY', 'MEZA ', '00000000', 'lima', '', 'susana@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(26, 'ABEL VARGAS', ' ', '00000000', 'PICHANAQUI', '', 'aldo@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(27, 'ALICIA PALLE', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(28, 'TALIA ', 'TAFUR ZEVALLOS', '45454545', 'TINGO MARIA', '962386185', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(29, 'DEISI', 'CORONEL HUMAN', '12121212', 'TOCACHE', '958088106', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(30, 'Yesica Mese ', 'MEZA MEZA', '123123445', 'Jr. mesa 538', '949684193', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(31, 'Magaly', 'Chota Chota', '45454545', 'jr. chota 560', '9496841932', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(32, 'MANUEL CORRALES', 'GYM ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(33, 'Frank Pucallpa', 'Pucallpa Pucallpa', '45454545', 'pucallpa 650', '993437558', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(34, 'Nery', 'Jaen Mesa Redonda', '00000000', 'mesa redonda', '949684193', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(35, 'RICARDO', 'MAYTA CHICLOTE', '00000000', 'lima', '944621519', 'ricardo1mayta@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(36, 'Rosmeri ', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(37, 'LILIAN', 'CORTEGANA TELLO', '00000000', 'CELENDIN', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(38, 'ISADORA UMAN', ' ', '00000000', 'CELENDIN', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(39, 'MANOLO', ' ', '00000000', 'CELENDIN', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(40, 'SANDRY MONICA', ' ', '00000000', 'MOYOBAMBA', '957462908', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(41, 'EDGAR', ' ', '00000000', 'CAJAMARCA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(42, 'YULLI', 'PIURA PIURA', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(43, 'ELIZABETH', ' ', '00000000', 'CHOTA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(44, 'ELIZABEHT', ' ', '00000000', 'CAJAMARCA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(45, 'ROXANA ', 'VASQUEZ HENOSTROZA', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(46, 'LEIVA BAMBAMARCA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(47, 'WILDER ESPINAL', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(48, 'Oscar', 'Velasquez  Diaz', '00000000', 'Celendin', '949684193', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(49, 'Kati', 'Vasquez Malvinas', '00000000', 'Malvinas', '949684193', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(50, 'MIGUEL', 'PARI AQUINO', '00000000', 'PICHANAQUI', '950454678', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(51, 'ABEL TARAPOTO', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(52, 'Alindor', 'Mendoza Hoyos', '00000000', 'Cajamarca', '976777777', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(53, 'Brenda', 'Arce Arce', '00000000', 'mesa redonda', '949684193', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(54, 'PERCY', 'LOZANO LOZANO', '00000000', 'LIMA', '949684193', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(55, 'OSCAR', 'Velasquez  Diaz', '00000000', 'Celendin', '9496894193', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(56, 'MARTIN', 'TORRES RAMOS', '00000000', 'SATIPO', '', 'toledo861@hotmail.com', 1, 1, 2, '0000-00-00', NULL, NULL),
(57, 'RICARDO', 'AQUINO  LOPEZ', '00000000', 'CAJAMARCA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(58, 'LENIN MESA', 'LIMA ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(59, 'MAGNA', 'SILVESTRE LOAIZA', '00000000', 'TARMA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(60, 'JHONY  FERRENAFE', ' ', '00000000', 'MALVINAS', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(61, 'ANITA ', 'COUYO SOLIZ', '00000000', 'Mesa Redonda 1er piso', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(62, 'GABRIELA', ' ', '00000000', 'LIMA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(63, 'MAGALY', 'DIAZ VELAZQUEZ', '00000000', 'CHOTA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(64, 'GILMER', 'HUAMAN  ', '00000000', 'LIMA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(65, 'ADOLFO', 'CERRON CERRON', '00000000', 'LIMA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(66, 'MANOLO', 'CELENDIN CELENDIN', '00000000', 'CELENDIN', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(67, 'ALFREDO', 'CHAMARRO CHAMARRO', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(68, 'rosa ', 'leiva ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(69, 'RICARDO MAITA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(70, 'GREGORIO', 'MANANAY RODRIGUEZ', '00000000', 'MOYOBAMABA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(71, 'ROSA', 'LEIVA ESQUIEN', '00000000', 'CHOTA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(72, 'REYES', 'HUAMAN  SAUCEDO', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(73, 'ESTEFANY LUNA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(74, 'z', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(75, 'NORVIL', 'BLANCO BENAVIDES', '00000000', 'BAMABAMARCA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(76, 'zzz', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(77, 'YENY', 'DE LA CRUZ NOA', '00000000', 'PICHANAQUI', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(78, 'MERVIL', 'DELA CRUZ NOA ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(79, 'RUTH', 'MAMANI ', '00000000', 'MESA REDONDA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(80, 'MARGARITA', 'MAMANI  CONDORI', '00000000', 'LIMA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(81, 'ALEX VASQUEZ BAMBAMA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(82, 'zz', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(83, 'MARITZA', 'TRUJILLO ALVARADO ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(84, 'MILAGROS', 'REINA  MOSQUEDA', '00000000', 'IQUITOS', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(85, 'ALEX ', 'COPA  MAMANI', '00000000', 'TRUJILLO', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(86, 'JHOEL BAMBAMARCA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(87, 'JOSÃ‰ LUIS', 'RAMOS RAMOS', '00000000', 'PANGOA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(88, 'MARLLINI ', 'VASQUEZ HENOSTROZA', '00000000', 'HUARAZ', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(89, 'YINER', 'TOLEDO ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(90, 'DANY MESA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(91, 'irma ', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(92, 'ADELIA HUAMAN ', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(93, 'WILDER BAMBAMARCA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(94, 'OSCAR HUAMAN', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(95, 'RUDY BRIONES DIAS', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(96, 'DANTE', 'HOYOS ', '00000000', 'LIMA', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(97, 'OSCAR HUAMAN SAUCEDO', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(98, 'ROXANA HENOSTROZA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(99, 'EDELMIRA', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL),
(100, 'MARI ABANTO', ' ', '00000000', '', '', '', 1, 1, 2, '0000-00-00', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_compra`
--

CREATE TABLE `sm_compra` (
  `C_C_CODIGO` int(11) NOT NULL,
  `PV_C_CODIGO` int(11) NOT NULL,
  `US_C_CODIGO` int(11) NOT NULL,
  `C_N_TOTAL` decimal(8,2) NOT NULL,
  `C_C_CANCELADO` decimal(8,2) NOT NULL,
  `C_N_NUMDOC` varchar(20) NOT NULL,
  `T_C_CODIGO` int(11) NOT NULL,
  `C_F_FECHA` date NOT NULL,
  `C_E_ESTADO` int(11) NOT NULL DEFAULT '1',
  `SED_C_CODIGO` int(11) NOT NULL,
  `AUD_F_FECHAINSERCION` date DEFAULT NULL,
  `AUD_U_USARIOCREA` int(11) DEFAULT NULL,
  `AUD_F_FECHAMODIFICACION` date DEFAULT NULL,
  `AUD_U_USARIOMOFICIA` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_compra`
--

INSERT INTO `sm_compra` (`C_C_CODIGO`, `PV_C_CODIGO`, `US_C_CODIGO`, `C_N_TOTAL`, `C_C_CANCELADO`, `C_N_NUMDOC`, `T_C_CODIGO`, `C_F_FECHA`, `C_E_ESTADO`, `SED_C_CODIGO`, `AUD_F_FECHAINSERCION`, `AUD_U_USARIOCREA`, `AUD_F_FECHAMODIFICACION`, `AUD_U_USARIOMOFICIA`) VALUES
(1531, 1, 1, '432.00', '0.00', '000000001', 1, '0000-00-00', 0, 1, '2017-06-06', 1, NULL, NULL),
(1532, 1, 1, '344.00', '0.00', '000000002', 1, '0000-00-00', 1, 1, '2017-06-06', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_cuentasCompras`
--

CREATE TABLE `sm_cuentasCompras` (
  `CC_C_CODIGO` int(11) NOT NULL,
  `PV_C_CODIGO` int(11) NOT NULL,
  `CC_N_TOTAL` decimal(8,2) NOT NULL,
  `CC_N_CANCELA` decimal(8,2) NOT NULL,
  `CC_F_FECHA` datetime NOT NULL,
  `CC_E_ESTADO` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_cuentasVentas`
--

CREATE TABLE `sm_cuentasVentas` (
  `CV_C_CODIGO` int(11) NOT NULL,
  `CLI_C_CODIGO` int(11) NOT NULL,
  `CV_N_TOTAL` decimal(8,2) NOT NULL,
  `CV_N_CANCELA` decimal(8,2) NOT NULL,
  `CV_F_FECHA` datetime NOT NULL,
  `CV_E_ESTADO` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_departamento`
--

CREATE TABLE `sm_departamento` (
  `DEP_C_CODIGO` varchar(2) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `DEP_D_NOMBREDEPARTAMENTO` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_depositos`
--

CREATE TABLE `sm_depositos` (
  `DEP_C_CODIGO` int(11) NOT NULL,
  `US_C_CODIGO` int(11) NOT NULL,
  `DEP_N_MONTO` decimal(8,2) NOT NULL,
  `DEP_D_IMAGEN` varchar(100) NOT NULL,
  `DEP_E_ESTADO` int(11) NOT NULL,
  `DEP_D_OBS` varchar(100) NOT NULL,
  `DEP_F_FECHA` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_detordenes`
--

CREATE TABLE `sm_detordenes` (
  `DTL_C_CODIGO` int(11) NOT NULL,
  `PRO_C_CODIGO` int(11) DEFAULT NULL,
  `ORD_C_CODIGO` int(11) DEFAULT NULL,
  `DTL_N_CANTIDAD` decimal(8,2) DEFAULT NULL,
  `DTL_N_PRECOMPRA` decimal(10,2) NOT NULL,
  `DTL_N_PRECIOVENTA` decimal(8,2) DEFAULT NULL,
  `DTL_N_IMPORTE` decimal(8,2) DEFAULT NULL,
  `DTL_N_DESCUENTO` decimal(8,2) NOT NULL,
  `DTL_E_ESTADO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_detordenes`
--

INSERT INTO `sm_detordenes` (`DTL_C_CODIGO`, `PRO_C_CODIGO`, `ORD_C_CODIGO`, `DTL_N_CANTIDAD`, `DTL_N_PRECOMPRA`, `DTL_N_PRECIOVENTA`, `DTL_N_IMPORTE`, `DTL_N_DESCUENTO`, `DTL_E_ESTADO`) VALUES
(136, 73, 10, '1.00', '551.00', '0.00', '0.00', '0.00', 1),
(137, 73, 11, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(138, 73, 11, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(139, 73, 11, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(140, 73, 11, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(141, 73, 11, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(142, 73, 11, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(143, 73, 12, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(144, 73, 12, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(145, 73, 12, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(146, 137, 13, '2.00', '130.00', '210.00', '630.00', '0.00', 1),
(147, 138, 13, '1.00', '253.00', '490.00', '490.00', '0.00', 1),
(148, 137, 14, '1.00', '130.00', '210.00', '210.00', '0.00', 1),
(149, 138, 14, '2.00', '253.00', '490.00', '980.00', '0.00', 1),
(150, 137, 15, '1.00', '130.00', '210.00', '210.00', '0.00', 1),
(151, 137, 19, '2.00', '130.00', '210.00', '420.00', '0.00', 1),
(152, 73, 19, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(153, 116, 20, '1.00', '188.00', '195.00', '195.00', '0.00', 1),
(154, 73, 20, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(155, 137, 22, '1.00', '130.00', '210.00', '210.00', '0.00', 1),
(156, 209, 22, '1.00', '203.00', '330.00', '330.00', '0.00', 1),
(157, 214, 22, '1.00', '129.00', '0.00', '0.00', '0.00', 1),
(158, 138, 23, '1.00', '253.00', '490.00', '490.00', '0.00', 1),
(159, 256, 28, '2.00', '78.00', '85.00', '170.00', '0.00', 1),
(160, 287, 28, '2.00', '240.00', '260.00', '520.00', '0.00', 1),
(161, 243, 28, '1.00', '128.00', '138.00', '138.00', '0.00', 1),
(162, 256, 31, '2.00', '78.00', '85.00', '170.00', '0.00', 1),
(163, 139, 31, '1.00', '290.00', '389.00', '389.00', '0.00', 1),
(164, 256, 44, '1.00', '78.00', '85.00', '85.00', '0.00', 1),
(165, 256, 45, '1.00', '78.00', '85.00', '85.00', '0.00', 1),
(166, 190, 46, '3.00', '92.50', '105.00', '315.00', '0.00', 1),
(167, 191, 46, '7.00', '92.50', '105.00', '735.00', '0.00', 1),
(168, 338, 46, '2.00', '200.00', '215.00', '430.00', '0.00', 1),
(169, 85, 46, '2.00', '7.00', '8.00', '16.00', '0.00', 1),
(170, 338, 47, '1.00', '200.00', '215.00', '215.00', '0.00', 1),
(171, 126, 48, '1.00', '170.00', '240.00', '240.00', '0.00', 1),
(172, 226, 49, '1.00', '42.00', '53.00', '53.00', '0.00', 1),
(173, 42, 50, '1.00', '285.00', '87.00', '87.00', '0.00', 1),
(174, 349, 51, '1.00', '1.00', '1.00', '1.00', '0.00', 1),
(175, 226, 54, '1.00', '42.00', '53.00', '53.00', '0.00', 1),
(176, 226, 55, '1.00', '42.00', '53.00', '53.00', '0.00', 1),
(177, 350, 56, '1.00', '1.00', '1.00', '1.00', '0.00', 1),
(178, 226, 57, '1.00', '42.00', '53.00', '53.00', '0.00', 1),
(179, 85, 58, '1.00', '7.00', '8.00', '8.00', '0.00', 1),
(180, 85, 59, '1.00', '7.00', '8.00', '8.00', '0.00', 1),
(181, 85, 60, '1.00', '7.00', '8.00', '8.00', '0.00', 1),
(182, 85, 61, '1.00', '7.00', '8.00', '8.00', '0.00', 1),
(183, 85, 62, '1.00', '7.00', '8.00', '8.00', '0.00', 1),
(184, 85, 63, '5.00', '7.00', '8.00', '40.00', '0.00', 1),
(185, 226, 63, '4.00', '42.00', '53.00', '212.00', '0.00', 1),
(186, 85, 65, '2.00', '7.00', '5.00', '10.00', '0.00', 1),
(187, 85, 66, '2.00', '7.00', '9.00', '18.00', '0.00', 1),
(188, 85, 67, '1.00', '7.00', '5.00', '5.00', '0.00', 1),
(189, 85, 68, '4.00', '7.00', '10.00', '40.00', '0.00', 1),
(190, 85, 69, '1.00', '7.00', '9.00', '9.00', '0.00', 1),
(191, 85, 70, '1.00', '7.00', '8.00', '8.00', '0.00', 1),
(192, 85, 71, '1.00', '7.00', '8.00', '8.00', '0.00', 1),
(193, 85, 72, '1.00', '7.00', '5.00', '5.00', '0.00', 1),
(194, 85, 73, '1.00', '7.00', '9.00', '9.00', '0.00', 1),
(195, 85, 75, '77.00', '7.00', '20.00', '1540.00', '0.00', 1),
(196, 189, 75, '2.00', '90.00', '105.00', '210.00', '0.00', 1),
(197, 85, 76, '1.00', '7.00', '8.00', '8.00', '0.00', 1),
(198, 85, 77, '2.00', '7.00', '8.00', '16.00', '0.00', 1),
(199, 189, 77, '1.00', '90.00', '105.00', '105.00', '0.00', 1),
(200, 190, 79, '1.00', '92.50', '105.00', '105.00', '0.00', 1),
(201, 189, 80, '1.00', '90.00', '105.00', '105.00', '0.00', 1),
(202, 139, 81, '1.00', '290.00', '389.00', '389.00', '0.00', 1),
(203, 189, 82, '3.00', '90.00', '105.00', '315.00', '0.00', 1),
(204, 189, 85, '1.00', '90.00', '110.00', '110.00', '0.00', 1),
(205, 190, 86, '2.00', '92.50', '105.00', '210.00', '0.00', 1),
(206, 189, 87, '2.00', '90.00', '111.00', '222.00', '0.00', 1),
(207, 191, 88, '2.00', '92.50', '700.00', '1400.00', '0.00', 1),
(208, 84, 90, '2.00', '3.00', '4.50', '9.00', '0.00', 1),
(209, 84, 91, '2.00', '3.00', '7.00', '14.00', '0.00', 1),
(210, 164, 91, '2.00', '143.00', '160.00', '320.00', '0.00', 1),
(211, 295, 91, '5.00', '58.00', '70.00', '350.00', '0.00', 1),
(212, 295, 94, '3.00', '58.00', '70.00', '210.00', '0.00', 1),
(213, 295, 95, '2.00', '58.00', '70.00', '140.00', '0.00', 1),
(214, 295, 98, '1.00', '58.00', '70.00', '70.00', '0.00', 1),
(215, 190, 99, '3.00', '92.50', '105.00', '315.00', '0.00', 1),
(216, 299, 100, '3.00', '131.00', '135.00', '405.00', '0.00', 1),
(217, 295, 101, '3.00', '58.00', '78.20', '234.60', '0.00', 1),
(218, 84, 101, '4.00', '3.00', '9.50', '38.00', '0.00', 1),
(219, 191, 101, '1.00', '92.50', '105.00', '105.00', '0.00', 1),
(220, 84, 102, '3.00', '3.00', '6.00', '18.00', '0.00', 1),
(221, 295, 102, '3.00', '58.00', '70.00', '210.00', '0.00', 1),
(222, 164, 103, '1.00', '143.00', '160.00', '160.00', '0.00', 1),
(223, 84, 104, '5.00', '3.00', '4.50', '22.50', '0.00', 1),
(224, 295, 104, '5.00', '58.00', '70.00', '350.00', '0.00', 1),
(225, 310, 105, '3.00', '42.00', '60.00', '180.00', '0.00', 1),
(226, 310, 106, '2.00', '42.00', '50.00', '100.00', '0.00', 1),
(227, 310, 107, '1.00', '42.00', '50.00', '50.00', '0.00', 1),
(228, 226, 108, '1.00', '42.00', '53.00', '53.00', '0.00', 1),
(229, 310, 110, '1.00', '42.00', '50.00', '50.00', '0.00', 0),
(230, 139, 110, '1.00', '290.00', '389.00', '389.00', '0.00', 0),
(231, 189, 110, '0.00', '90.00', '105.00', '105.00', '0.00', 0),
(232, 190, 110, '2.00', '92.50', '105.00', '210.00', '0.00', 0),
(233, 191, 110, '2.00', '92.50', '105.00', '210.00', '0.00', 0),
(234, 201, 110, '0.00', '300.00', '350.00', '350.00', '0.00', 0),
(235, 311, 110, '5.00', '55.00', '60.00', '300.00', '0.00', 0),
(236, 336, 110, '0.00', '511.00', '0.00', '0.00', '0.00', 0),
(237, 311, 111, '1.00', '55.00', '61.00', '61.00', '0.00', 1),
(238, 201, 112, '0.00', '300.00', '350.00', '350.00', '0.00', 0),
(239, 261, 113, '1.00', '502.00', '570.00', '570.00', '0.00', 1),
(240, 261, 127, '1.00', '502.00', '560.00', '560.00', '0.00', 1),
(241, 201, 127, '1.00', '300.00', '350.00', '350.00', '0.00', 1),
(242, 138, 131, '1.00', '253.00', '490.00', '490.00', '0.00', 1),
(243, 287, 131, '1.00', '240.00', '260.00', '260.00', '0.00', 1),
(244, 73, 132, '0.00', '551.00', '660.00', '660.00', '0.00', 0),
(245, 243, 132, '1.00', '128.00', '138.00', '138.00', '0.00', 1),
(246, 137, 133, '1.00', '130.00', '200.00', '200.00', '0.00', 1),
(247, 284, 133, '1.00', '725.00', '800.00', '800.00', '0.00', 1),
(248, 85, 133, '0.00', '7.00', '8.00', '8.00', '0.00', 0),
(249, 137, 135, '1.00', '130.00', '210.00', '210.00', '0.00', 1),
(250, 243, 136, '1.00', '128.00', '138.00', '138.00', '0.00', 1),
(251, 73, 136, '1.00', '551.00', '660.00', '660.00', '0.00', 1),
(252, 185, 136, '0.00', '282.00', '380.00', '380.00', '0.00', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_detvista`
--

CREATE TABLE `sm_detvista` (
  `DTV_C_CODIGO` int(11) NOT NULL,
  `US_C_CODIGO` int(11) NOT NULL,
  `VIS_C_CODIGO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_distrito`
--

CREATE TABLE `sm_distrito` (
  `DIS_C_CODIGO` varchar(6) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `DIS_D_NOMBREDISTRITO` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `P_C_CODIGO` varchar(4) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_dtcompras`
--

CREATE TABLE `sm_dtcompras` (
  `COM_C_CODIGO` int(11) NOT NULL,
  `C_C_CODIGO` int(11) NOT NULL,
  `PRO_C_CODIGO` int(11) NOT NULL,
  `COM_N_PRECIOC` decimal(8,2) NOT NULL,
  `COM_N_CANTIDAD` int(11) NOT NULL,
  `COM_F_FECHA` date NOT NULL,
  `COM_C_CBARRA` varchar(50) NOT NULL,
  `COM_E_ESTADO` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_dtventas`
--

CREATE TABLE `sm_dtventas` (
  `DVE_C_CODIGO` int(11) NOT NULL,
  `PRO_C_CODIGO` int(11) NOT NULL,
  `VEN_C_CODIGO` int(11) NOT NULL,
  `DVE_N_CANTIDAD` decimal(8,2) NOT NULL,
  `DVE_N_PRECIO` decimal(8,2) NOT NULL,
  `DVE_E_ESTADO` int(11) NOT NULL,
  `DVE_N_PRECIOC` decimal(8,2) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_entregas_pro`
--

CREATE TABLE `sm_entregas_pro` (
  `ENTP_C_CODIGO` int(11) NOT NULL,
  `DTL_C_CODIGO` int(11) DEFAULT NULL,
  `PRO_C_CODIGO` int(11) DEFAULT NULL,
  `CLI_C_CODIGO` int(11) DEFAULT NULL,
  `ENTP_NOMPRO` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `ENTP_N_CANTIDAD` int(11) DEFAULT NULL,
  `ENTP_N_PC` decimal(8,2) DEFAULT NULL,
  `ENTP_N_PV` decimal(8,2) DEFAULT NULL,
  `ENTP_D_FECHAENTREGA` date DEFAULT NULL,
  `ENTP_N_DESCUENTO` decimal(8,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_estadocivil`
--

CREATE TABLE `sm_estadocivil` (
  `EC_C_CODIGO` int(11) NOT NULL,
  `EC_D_NOMBRE` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_hisVentas`
--

CREATE TABLE `sm_hisVentas` (
  `HVE_C_CODIGO` int(11) NOT NULL,
  `HVE_N_COMPRAS` decimal(8,2) NOT NULL,
  `HVE_N_VENTAS` decimal(8,2) NOT NULL,
  `HVE_N_GANANCIA` decimal(8,2) NOT NULL,
  `HVE_F_FECHA` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_imgs`
--

CREATE TABLE `sm_imgs` (
  `IMG_C_CODIGO` int(11) NOT NULL,
  `PRO_C_CODIGO` int(11) NOT NULL,
  `IMG_E_ENLACE` varchar(150) NOT NULL,
  `IMG_E_ESTADO` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_ingcat`
--

CREATE TABLE `sm_ingcat` (
  `ICT_C_CODIGO` int(11) NOT NULL,
  `ICT_D_NOMBRE` varchar(50) NOT NULL,
  `ICT_E_ESTADO` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_marca`
--

CREATE TABLE `sm_marca` (
  `MAR_C_CODIGO` int(11) NOT NULL,
  `MAR_D_NOMBRE` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `AUD_F_FECHAINSERCION` date DEFAULT NULL,
  `AUD_U_USARIOCREA` int(11) DEFAULT NULL,
  `AUD_F_FECHAMODIFICACION` date DEFAULT NULL,
  `AUD_U_USARIOMOFICIA` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_marca`
--

INSERT INTO `sm_marca` (`MAR_C_CODIGO`, `MAR_D_NOMBRE`, `AUD_F_FECHAINSERCION`, `AUD_U_USARIOCREA`, `AUD_F_FECHAMODIFICACION`, `AUD_U_USARIOMOFICIA`) VALUES
(1, '	 Acer	', '2015-04-27', 2, NULL, NULL),
(2, '	 AEG	', '2015-04-27', 2, NULL, NULL),
(3, '	 Airam	', '2015-04-27', 2, NULL, NULL),
(4, '	 Alcatel', '2015-04-27', 2, NULL, NULL),
(5, '	 Amazon	', '2015-04-27', 2, NULL, NULL),
(6, '	 Amoi	', '2015-04-27', 2, NULL, NULL),
(7, '	 Anycool', '2015-04-27', 2, NULL, NULL),
(8, '	 Apple	', '2015-04-27', 2, NULL, NULL),
(9, '	 Asus	', '2015-04-27', 2, NULL, NULL),
(10, '	 Azumi	', '2015-04-27', 2, NULL, NULL),
(11, '	 BenQ	', '2015-04-27', 2, NULL, NULL),
(12, '	 BenQ Siemens	', '2015-04-27', 2, NULL, NULL),
(13, '	 Bird	', '2015-04-27', 2, NULL, NULL),
(14, '	 BlackBerry	', '2015-04-27', 2, NULL, NULL),
(15, '	 BLU	', '2015-04-27', 2, NULL, NULL),
(16, '	 Cect	', '2015-04-27', 2, NULL, NULL),
(17, '	 Dell	', '2015-04-27', 2, NULL, NULL),
(18, '	 Eten	', '2015-04-27', 2, NULL, NULL),
(19, '	 Geeksphone	', '2015-04-27', 2, NULL, NULL),
(20, '	 General Mobile	', '2015-04-27', 2, NULL, NULL),
(21, '	 Gigabyte	', '2015-04-27', 2, NULL, NULL),
(22, '	 Gradiente	', '2015-04-27', 2, NULL, NULL),
(23, '	 Haier	', '2015-04-27', 2, NULL, NULL),
(24, '	 HP	', '2015-04-27', 2, NULL, NULL),
(25, '	 HTC	', '2015-04-27', 2, NULL, NULL),
(26, '	 Huawei	', '2015-04-27', 2, NULL, NULL),
(27, '	 Hyundai	', '2015-04-27', 2, NULL, NULL),
(28, '	 i-mate	', '2015-04-27', 2, NULL, NULL),
(29, '	 i-mobile	', '2015-04-27', 2, NULL, NULL),
(30, '	 iNQ	', '2015-04-27', 2, NULL, NULL),
(31, '	 Jolla	', '2015-04-27', 2, NULL, NULL),
(32, '	 Lanix	', '2015-04-27', 2, NULL, NULL),
(33, '	 Lenovo	', '2015-04-27', 2, NULL, NULL),
(34, '	 LG	', '2015-04-27', 2, NULL, NULL),
(35, '	 Meizu	', '2015-04-27', 2, NULL, NULL),
(36, '	 Microsoft	', '2015-04-27', 2, NULL, NULL),
(37, '	 Modu	', '2015-04-27', 2, NULL, NULL),
(38, '	 Motorola	', '2015-04-27', 2, NULL, NULL),
(39, '	 Movistar	', '2015-04-27', 2, NULL, NULL),
(40, '	 NEC	', '2015-04-27', 2, NULL, NULL),
(41, '	 Nokia	', '2015-04-27', 2, NULL, NULL),
(42, '	 O2	', '2015-04-27', 2, NULL, NULL),
(43, '	 OnePlus	', '2015-04-27', 2, NULL, NULL),
(44, '	 Oppo	', '2015-04-27', 2, NULL, NULL),
(45, '	 Orange	', '2015-04-27', 2, NULL, NULL),
(46, '	 Palm	', '2015-04-27', 2, NULL, NULL),
(47, '	 Panasonic	', '2015-04-27', 2, NULL, NULL),
(48, '	 Pantech	', '2015-04-27', 2, NULL, NULL),
(49, '	 Philips	', '2015-04-27', 2, NULL, NULL),
(50, '	 Qtek	', '2015-04-27', 2, NULL, NULL),
(51, '	 Sagem	', '2015-04-27', 2, NULL, NULL),
(52, '	 Samsung	', '2015-04-27', 2, NULL, NULL),
(53, '	 Sharp	', '2015-04-27', 2, NULL, NULL),
(54, '	 Siemens	', '2015-04-27', 2, NULL, NULL),
(55, '	 Skyzen	', '2015-04-27', 2, NULL, NULL),
(56, '	 Sony	', '2015-04-27', 2, NULL, NULL),
(57, '	 Sony Ericsson	', '2015-04-27', 2, NULL, NULL),
(58, '	 TCL	', '2015-04-27', 2, NULL, NULL),
(59, '	 Telit	', '2015-04-27', 2, NULL, NULL),
(60, '	 Toshiba	', '2015-04-27', 2, NULL, NULL),
(61, '	 Vertu	', '2015-04-27', 2, NULL, NULL),
(62, '	 Verykool	', '2015-04-27', 2, NULL, NULL),
(63, '	 ViewSonic	', '2015-04-27', 2, NULL, NULL),
(64, '	 Vodafone	', '2015-04-27', 2, NULL, NULL),
(65, '	 Xiaomi	', '2015-04-27', 2, NULL, NULL),
(66, '	 ZTE	', '2015-04-27', 2, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_ordenes`
--

CREATE TABLE `sm_ordenes` (
  `ORD_C_CODIGO` int(11) NOT NULL,
  `CLI_C_CODIGO` int(11) NOT NULL,
  `ORD_D_OBSERVACIONES` varchar(200) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `ORD_C_TIPODOC` int(11) NOT NULL,
  `ORD_N_DESCUENTO` decimal(8,2) NOT NULL,
  `ORD_E_ESTADO` int(11) NOT NULL,
  `AUD_C_USUCREA` int(11) NOT NULL,
  `AUD_F_FECHACREA` datetime DEFAULT NULL,
  `AUD_C_USUMOD` bigint(20) DEFAULT NULL,
  `AUD_F_FECHAMOD` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_ordenes`
--

INSERT INTO `sm_ordenes` (`ORD_C_CODIGO`, `CLI_C_CODIGO`, `ORD_D_OBSERVACIONES`, `ORD_C_TIPODOC`, `ORD_N_DESCUENTO`, `ORD_E_ESTADO`, `AUD_C_USUCREA`, `AUD_F_FECHACREA`, `AUD_C_USUMOD`, `AUD_F_FECHAMOD`) VALUES
(1, 35, NULL, 0, '0.00', 0, 2, '2016-08-14 08:15:07', NULL, NULL),
(2, 57, NULL, 0, '0.00', 0, 2, '2016-08-14 08:22:56', NULL, NULL),
(3, 57, NULL, 0, '0.00', 0, 2, '2016-08-14 08:25:33', NULL, NULL),
(4, 57, NULL, 0, '0.00', 0, 2, '2016-08-14 08:26:40', NULL, NULL),
(5, 57, NULL, 0, '0.00', 0, 2, '2016-08-14 08:29:28', NULL, NULL),
(6, 64, NULL, 0, '0.00', 0, 2, '2016-08-14 08:31:47', NULL, NULL),
(7, 64, NULL, 0, '0.00', 0, 2, '2016-08-14 08:39:25', NULL, NULL),
(8, 57, NULL, 0, '0.00', 0, 2, '2016-08-14 16:56:37', NULL, NULL),
(9, 35, NULL, 0, '0.00', 0, 2, '2016-08-14 16:56:52', NULL, NULL),
(10, 35, NULL, 0, '0.00', 0, 2, '2016-08-15 01:29:06', NULL, NULL),
(11, 57, NULL, 0, '0.00', 0, 2, '2016-08-15 01:37:44', NULL, NULL),
(12, 57, NULL, 0, '0.00', 1, 2, '2016-08-15 01:52:22', NULL, NULL),
(13, 1, NULL, 0, '0.00', 0, 2, '2016-08-15 02:25:28', NULL, NULL),
(14, 1, NULL, 0, '0.00', 1, 2, '2016-08-15 02:38:38', NULL, NULL),
(15, 64, NULL, 0, '0.00', 1, 2, '2016-08-15 03:47:19', NULL, NULL),
(16, 64, NULL, 0, '0.00', 0, 2, '2016-08-15 03:51:30', NULL, NULL),
(17, 64, NULL, 0, '0.00', 0, 2, '2016-08-15 03:51:42', NULL, NULL),
(18, 64, NULL, 0, '0.00', 0, 2, '2016-08-15 03:51:42', NULL, NULL),
(19, 1, NULL, 0, '0.00', 1, 2, '2016-08-15 03:57:23', NULL, NULL),
(20, 64, NULL, 0, '0.00', 1, 2, '2016-08-15 04:07:26', NULL, NULL),
(21, 64, NULL, 0, '0.00', 0, 2, '2016-08-15 05:02:17', NULL, NULL),
(22, 64, NULL, 0, '0.00', 1, 2, '2016-08-15 05:04:52', NULL, NULL),
(23, 16, NULL, 0, '0.00', 1, 2, '2016-08-15 05:13:54', NULL, NULL),
(24, 1, NULL, 0, '0.00', 0, 2, '2016-08-15 05:48:20', NULL, NULL),
(25, 1, NULL, 0, '0.00', 0, 2, '2016-08-15 05:49:30', NULL, NULL),
(26, 1, NULL, 0, '0.00', 0, 2, '2016-08-15 05:51:09', NULL, NULL),
(27, 1, NULL, 0, '0.00', 0, 2, '2016-08-15 05:52:21', NULL, NULL),
(28, 1, NULL, 0, '0.00', 0, 2, '2016-08-15 05:53:32', NULL, NULL),
(29, 16, NULL, 0, '0.00', 0, 2, '2016-08-15 05:58:57', NULL, NULL),
(30, 64, NULL, 0, '0.00', 0, 2, '2016-08-15 06:01:38', NULL, NULL),
(31, 1, NULL, 0, '0.00', 0, 2, '2016-08-15 14:00:03', NULL, NULL),
(34, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 05:43:27', NULL, NULL),
(35, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 05:44:37', NULL, NULL),
(36, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 05:45:11', NULL, NULL),
(37, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 06:02:36', NULL, NULL),
(38, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 06:03:01', NULL, NULL),
(39, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 06:07:01', NULL, NULL),
(40, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 06:07:33', NULL, NULL),
(41, 57, NULL, 0, '0.00', 0, 2, '2016-08-18 06:08:08', NULL, NULL),
(42, 57, NULL, 0, '0.00', 0, 2, '2016-08-18 06:10:16', NULL, NULL),
(43, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 06:10:54', NULL, NULL),
(44, 35, NULL, 0, '0.00', 1, 2, '2016-08-18 06:20:34', NULL, NULL),
(45, 1, NULL, 0, '0.00', 1, 2, '2016-08-18 06:22:08', NULL, NULL),
(46, 57, NULL, 0, '0.00', 1, 2, '2016-08-18 06:25:38', NULL, NULL),
(47, 64, NULL, 0, '0.00', 1, 2, '2016-08-18 07:05:37', NULL, NULL),
(48, 1, NULL, 0, '0.00', 1, 2, '2016-08-18 07:12:14', NULL, NULL),
(49, 1, NULL, 0, '0.00', 1, 2, '2016-08-18 07:14:04', NULL, NULL),
(50, 1, NULL, 0, '0.00', 1, 2, '2016-08-18 07:19:03', NULL, NULL),
(51, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 07:20:58', NULL, NULL),
(52, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 07:23:12', NULL, NULL),
(53, 1, NULL, 0, '0.00', 0, 2, '2016-08-18 07:23:12', NULL, NULL),
(54, 1, NULL, 0, '0.00', 1, 2, '2016-08-18 07:23:16', NULL, NULL),
(55, 1, NULL, 0, '0.00', 1, 2, '2016-08-18 07:24:39', NULL, NULL),
(56, 1, NULL, 0, '0.00', 1, 2, '2016-08-18 07:27:54', NULL, NULL),
(57, 1, NULL, 0, '0.00', 1, 2, '2016-08-18 07:32:36', NULL, NULL),
(58, 64, NULL, 0, '0.00', 1, 2, '2016-08-18 17:21:57', NULL, NULL),
(59, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 04:03:28', NULL, NULL),
(60, 1, NULL, 0, '0.00', 0, 2, '2016-08-20 04:11:07', NULL, NULL),
(61, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 04:29:05', NULL, NULL),
(62, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 04:44:02', NULL, NULL),
(63, 35, NULL, 0, '0.00', 1, 2, '2016-08-20 04:59:48', NULL, NULL),
(64, 1, NULL, 0, '0.00', 0, 2, '2016-08-20 04:59:52', NULL, NULL),
(65, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:02:26', NULL, NULL),
(66, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:08:50', NULL, NULL),
(67, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:10:52', NULL, NULL),
(68, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:35:11', NULL, NULL),
(69, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:37:08', NULL, NULL),
(70, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:38:24', NULL, NULL),
(71, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:45:36', NULL, NULL),
(72, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:47:27', NULL, NULL),
(73, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:48:58', NULL, NULL),
(74, 1, NULL, 0, '0.00', 0, 2, '2016-08-20 06:49:29', NULL, NULL),
(75, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:55:52', NULL, NULL),
(76, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:57:13', NULL, NULL),
(77, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:58:08', NULL, NULL),
(78, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 06:58:45', NULL, NULL),
(79, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:00:20', NULL, NULL),
(80, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:04:12', NULL, NULL),
(81, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:06:02', NULL, NULL),
(82, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:06:46', NULL, NULL),
(83, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:07:04', NULL, NULL),
(84, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:07:04', NULL, NULL),
(85, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:08:17', NULL, NULL),
(86, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:16:45', NULL, NULL),
(87, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:17:34', NULL, NULL),
(88, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:20:45', NULL, NULL),
(89, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:24:18', NULL, NULL),
(90, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:27:41', NULL, NULL),
(91, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:30:34', NULL, NULL),
(92, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:30:36', NULL, NULL),
(93, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:30:36', NULL, NULL),
(94, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:36:08', NULL, NULL),
(95, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:38:19', NULL, NULL),
(96, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:39:11', NULL, NULL),
(97, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:39:15', NULL, NULL),
(98, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:39:19', NULL, NULL),
(99, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:41:39', NULL, NULL),
(100, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:47:58', NULL, NULL),
(101, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 07:49:51', NULL, NULL),
(102, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 08:00:37', NULL, NULL),
(103, 1, NULL, 0, '0.00', 1, 2, '2016-08-20 08:06:59', NULL, NULL),
(104, 16, NULL, 0, '0.00', 1, 2, '2016-08-21 00:24:43', NULL, NULL),
(105, 1, NULL, 0, '0.00', 1, 2, '2016-08-21 17:25:21', NULL, NULL),
(106, 1, NULL, 0, '0.00', 1, 2, '2016-08-21 18:12:09', NULL, NULL),
(107, 1, NULL, 0, '0.00', 1, 2, '2016-08-21 18:17:13', NULL, NULL),
(108, 1, NULL, 0, '0.00', 1, 2, '2016-08-21 18:19:20', NULL, NULL),
(109, 1, NULL, 0, '0.00', 1, 2, '2016-08-21 18:19:36', NULL, NULL),
(110, 16, NULL, 0, '0.00', 1, 2, '2016-08-21 18:20:32', NULL, NULL),
(111, 69, NULL, 0, '0.00', 1, 2, '2016-08-21 23:38:28', NULL, NULL),
(112, 1, NULL, 0, '0.00', 1, 2, '2016-08-22 16:53:27', NULL, NULL),
(113, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 05:27:26', NULL, NULL),
(114, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 06:54:37', NULL, NULL),
(115, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 06:56:04', NULL, NULL),
(116, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 06:56:14', NULL, NULL),
(117, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 06:59:33', NULL, NULL),
(118, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 07:00:01', NULL, NULL),
(119, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 07:01:22', NULL, NULL),
(120, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 07:04:18', NULL, NULL),
(121, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 07:10:44', NULL, NULL),
(122, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 07:18:45', NULL, NULL),
(123, 1, NULL, 0, '0.00', 1, 2, '2016-08-24 07:22:06', NULL, NULL),
(124, 1, NULL, 0, '0.00', 1, 2, '2016-08-25 03:26:40', NULL, NULL),
(125, 1, NULL, 0, '0.00', 1, 2, '2016-08-25 03:28:57', NULL, NULL),
(126, 1, NULL, 0, '0.00', 0, 2, '2016-08-25 03:29:42', NULL, NULL),
(127, 16, NULL, 0, '0.00', 1, 2, '2016-08-27 04:56:15', NULL, NULL),
(128, 1, NULL, 0, '0.00', 1, 2, '2016-08-30 15:51:49', NULL, NULL),
(129, 1, NULL, 0, '0.00', 0, 2, '2016-08-30 19:23:34', NULL, NULL),
(130, 1, NULL, 0, '0.00', 0, 2, '2016-08-30 19:29:18', NULL, NULL),
(131, 64, NULL, 0, '0.00', 1, 2, '2016-08-30 20:36:33', NULL, NULL),
(132, 64, NULL, 0, '0.00', 0, 2, '2016-08-30 20:47:11', NULL, NULL),
(133, 57, NULL, 0, '0.00', 1, 2, '2016-09-04 00:42:23', NULL, NULL),
(134, 64, NULL, 0, '0.00', 1, 2, '2016-09-04 00:57:51', NULL, NULL),
(135, 1, NULL, 0, '0.00', 1, 2, '2016-09-05 21:27:08', NULL, NULL),
(136, 10, NULL, 0, '0.00', 1, 2, '2016-12-23 21:17:24', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_pagosC`
--

CREATE TABLE `sm_pagosC` (
  `PC_C_CODIGO` int(11) NOT NULL,
  `PV_C_CODIGO` int(11) NOT NULL,
  `CC_C_CODIGO` int(11) NOT NULL,
  `PC_N_ABONA` decimal(8,2) NOT NULL,
  `PC_F_FECHA` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_pagoscompras`
--

CREATE TABLE `sm_pagoscompras` (
  `PGC_C_CODIGO` int(11) NOT NULL,
  `C_C_CODIGO` int(11) NOT NULL,
  `PGC_N_APAGAR` decimal(8,2) NOT NULL,
  `PGC_N_CANCELA` decimal(8,2) NOT NULL,
  `PGC_F_FECHA` date NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_pagosV`
--

CREATE TABLE `sm_pagosV` (
  `VV_C_CODIGO` int(11) NOT NULL,
  `CV_C_CODIGO` int(11) NOT NULL,
  `CLI_C_CODIGO` int(11) NOT NULL,
  `VV_N_ABONA` decimal(8,2) NOT NULL,
  `VV_F_FECHA` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_pagoventas`
--

CREATE TABLE `sm_pagoventas` (
  `PGV_C_CODIGO` int(11) NOT NULL,
  `VEN_C_CODIGO` int(11) NOT NULL,
  `PGV_N_CANCELAR` decimal(8,2) NOT NULL,
  `PGV_N_PAGA` decimal(8,2) NOT NULL,
  `PGV_F_FECHA` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_patrimonio`
--

CREATE TABLE `sm_patrimonio` (
  `PTR_C_CODIGO` int(11) NOT NULL,
  `ICT_C_CODIGO` int(11) NOT NULL,
  `PTR_N_MONTO` decimal(8,2) NOT NULL,
  `PTR_F_FECHA` datetime NOT NULL,
  `PTR_E_ESTADO` int(11) NOT NULL,
  `PTR_D_OBS` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_persona`
--

CREATE TABLE `sm_persona` (
  `PER_C_CODIGO` int(11) NOT NULL,
  `PER_D_NOMBRES` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `PER_D_APPPAT` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `PER_D_APPMAT` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `EC_C_CODIGO` int(11) DEFAULT NULL,
  `TD_C_CODIGO` int(11) DEFAULT NULL,
  `PER_D_NUMDOC` varchar(20) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `PER_F_FECHANAC` date DEFAULT NULL,
  `SEX_C_CODIGO` int(11) DEFAULT NULL,
  `PER_D_DIRECION` varchar(150) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `UBI_C_CODIGO` int(11) DEFAULT NULL,
  `PER_TELEFONO` varchar(20) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `PER_D_CORREO` varchar(100) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `PER_E_ESTADO` int(11) NOT NULL,
  `AUD_C_USUCREA` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `AUD_F_FECHACREA` date DEFAULT NULL,
  `AUD_C_USUMOD` int(11) DEFAULT NULL,
  `AUD_F_FECHAMOD` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_persona`
--

INSERT INTO `sm_persona` (`PER_C_CODIGO`, `PER_D_NOMBRES`, `PER_D_APPPAT`, `PER_D_APPMAT`, `EC_C_CODIGO`, `TD_C_CODIGO`, `PER_D_NUMDOC`, `PER_F_FECHANAC`, `SEX_C_CODIGO`, `PER_D_DIRECION`, `UBI_C_CODIGO`, `PER_TELEFONO`, `PER_D_CORREO`, `PER_E_ESTADO`, `AUD_C_USUCREA`, `AUD_F_FECHACREA`, `AUD_C_USUMOD`, `AUD_F_FECHAMOD`) VALUES
(1, 'RICARDO', 'MAYTA', 'CHICLOTE', 1, 1, '46834820', '1999-11-20', 1, 'LOS OLIVOS', 1, '995540350', 'ricardo1mayta@hotmail.com', 1, 'RICARDO', '2015-05-25', NULL, NULL),
(2, 'GILMER', 'HUAMAN', 'SAUCEDO', 1, 1, '46834820', '1989-11-12', 1, 'LOS OLIVOS', 2, '995540350', 'jilmer.engoldex@hotmail.com', 1, 'RICARDO', '2015-05-25', NULL, NULL),
(13, 'RICARDO', 'MAYTA', 'CHICLOTE', 1, 1, '46834820', '1990-11-20', 1, 'los olivos', 5, '944621519', 'ricmaybacilonn@hotmail.com', 1, '181.64.192.46\r\n', '2015-05-25', NULL, NULL),
(14, 'YINER', 'TOLEDO', 'DONATO', 1, 1, '43631410', '1987-10-08', 1, 'pichanaqui', 6, '945259425', 'yinertd@gmail.com', 1, '', '2015-05-27', NULL, NULL),
(15, 'REYES ', 'HUAMAN', 'SAUCEDO', 1, 1, '46016635', '1988-01-06', 1, 'av atahualpa 606', 7, '998075999', 'ryess_15_25@hotmail.com', 1, '190.234.105.10\r\n', '2015-05-28', NULL, NULL),
(16, 'MARCO', 'AZUCENA', 'DELGADO', 1, 1, '10510306', '1975-08-10', 1, 'Calle tres 2301 edificio 5 dpto 504 los parques del agustino', 8, '979143708', 'marcoazucena@outlook.com', 1, '132.184.0.135\r\n', '2015-08-11', NULL, NULL),
(17, 'NOE ', 'VEGA', 'CASTRO', 1, 1, '42636190', '1984-10-06', 1, 'Jiron Manuel Pasos 1252 SJM', 9, '940981717', 'noejorel@gmail.com', 1, '190.113.209.50\r\n', '2015-09-16', NULL, NULL),
(18, 'DANIEL', 'BRAVO', 'ATRULLA', 1, 1, '01560377', '1977-11-28', 1, 'mz c lote 2 urbanizacion san ignacio entre jr albiceas y jr magnoleas', 10, '942860059', 'danielbravoastrulla@hotmail.com', 1, '190.234.106.162\r\n', '2015-10-06', NULL, NULL),
(19, 'MARIANO', 'SILVA', 'RAMOS', 1, 1, '47102288', '1978-03-25', 1, 'Urb Rinconada 2Â° Etapa F-27', 11, '944193699', 'newmagio_xx@yahoo.es', 1, '190.42.85.210\r\n', '2015-11-04', NULL, NULL),
(21, 'LUIS', 'CABALLERO', '', 1, 1, '46834820', '1990-11-20', 1, 'LIMA MESA REDONDA', 13, '944621519', 'luis@hotamil.com', 1, '190.235.31.134\r\n', '2016-01-27', NULL, NULL),
(22, 'GREGORIO', 'YAURI', 'YAULILAHUA', 1, 1, '46834820', '1999-08-04', 1, 'SAN MARTIN PANGOA', 14, '989898987', 'GRE@HOTMAIL.COM', 1, '190.235.35.168\r\n', '2016-01-29', NULL, NULL),
(23, 'CLIENTE', 'NUEVO', '', 1, 1, '98989898', '1990-10-10', 1, 'LIMA MESA REDONDA', 14, '787878789', 'ventas@perucell.com', 1, '190.235.35.168\r\n', '2016-01-29', NULL, NULL),
(24, 'TENORIO', 'HUAMAN', 'SAUCEDO', 1, 1, '46758888', '2002-02-03', 1, 'CAJAMRCA CAMPAÃ‘AN', 16, '886578568', 'TINU@HOTMAIL.COM', 1, '190.235.35.168\r\n', '2016-01-29', NULL, NULL),
(25, 'LIZBET', 'SALAZAR', 'VILLAR', 1, 1, '64647373', '1990-04-10', 1, 'CELENDIN CAJAMRACA', 17, '75858484888', 'LIS@HOTMMAIL.COM', 1, '190.235.35.168\r\n', '2016-01-30', NULL, NULL),
(26, 'KELVIN', 'MAYTA', 'CRUZADO', 1, 1, '76767678', '1989-07-05', 1, 'CELENDIN CAJAMARCA', 18, '688678887', 'KELVIN@HOTMAIL.COM', 1, '200.106.35.133\r\n', '2016-01-30', NULL, NULL),
(27, 'TATIANA', 'CHACON ', 'SALAZAR', 1, 1, '5788788887', '1990-05-07', 1, 'CELENDIN CAJAMARCA', 19, '768799887', 'ricmaybacilon@hotmail.com', 1, '200.106.35.133\r\n', '2016-01-30', NULL, NULL),
(28, 'VICTOR ', 'LLOVERA', '', 1, 1, '65747484', '1999-05-03', 1, 'CAJAMRCA cajamarca', 20, '758547589', 'victor@gmail.com', 1, '200.106.35.133\r\n', '2016-01-30', NULL, NULL),
(29, 'RICHARD', 'SICCHA', 'SANCHES', 1, 1, '75845858', '2002-04-04', 1, 'HFJKHFLKJDSFL', 21, '8750384702570', 'ricardo1mayta@hotmail.com', 1, '200.106.35.133\r\n', '2016-01-31', NULL, NULL),
(30, 'LIZ RENE', 'HUAMAN', 'REYES', 1, 1, '4666526656', '2003-04-02', 2, 'pichanaki pichanaki', 22, '6585656522', 'ricardo@hotm.com', 1, '190.235.5.247\r\n', '2016-02-06', NULL, NULL),
(32, 'PILAR', 'MAMANI', 'MEZA', 1, 1, '00000000', '1990-11-20', 1, '', 24, '', '', 1, '190.43.77.66\r\n', '2016-02-09', NULL, NULL),
(33, 'WILDER', 'MEZA', '', 1, 1, '00000000', '1990-11-20', 1, '', 25, '', 'ricmaybacilon@hotmail.com', 1, '', '2016-02-09', NULL, NULL),
(34, 'YORDAN', 'MELGAR', '', 1, 1, '00000000', '1990-11-20', 1, 'SATIPO', 26, '', 'ricmaybacilon@hotmail.com', 1, '', '2016-02-09', NULL, NULL),
(35, 'FRANCISCO', 'MEZA', '', 1, 1, '00000000', '1990-11-20', 1, 'MEZA', 27, '', '', 1, 'TENORIO', '2016-02-09', NULL, NULL),
(36, 'ELDA', 'BARRAHONA', 'QUISPE', 1, 1, '46834820', '2003-03-02', 2, 'CUTERVO PERU', 28, '654521555', 'JAVIER@HOTMAIL.COM', 1, '190.43.77.66\r\n', '2016-02-09', NULL, NULL),
(37, 'EUGENIA', '', 'Pari', 1, 1, '26454545', '1994-09-13', 1, 'Jr. cuzco 520', 29, '949787878', 'toledo861@hotmail.com', 1, '200.121.154.12\r\n', '2016-02-12', NULL, NULL),
(38, 'susana', 'castrejon', 'jaen ', 1, 1, '00000000', '1990-11-20', 1, 'jr cajamarca ', 30, '995253689', 'susana@hotmail.com', 1, 'TENORIO', '2016-02-16', NULL, NULL),
(39, 'TONY', 'MEZA', '', 1, 1, '00000000', '1990-11-20', 1, 'lima', 31, '', 'susana@hotmail.com', 1, 'TENORIO', '2016-02-16', NULL, NULL),
(40, 'ABEL VARGAS', '', '', 1, 1, '00000000', '1990-11-20', 1, 'PICHANAQUI', 32, '', '', 1, 'TENORIO', '2016-02-16', NULL, NULL),
(41, 'ALICIA PALLE', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 33, '', '', 1, 'REYES', '2016-02-17', NULL, NULL),
(42, 'TALIA ', 'TAFUR', 'ZEVALLOS', 1, 1, '45454545', '1990-05-05', 1, 'TINGO MARIA', 33, '962386185', 'toledo861@hotmail.com', 1, '200.121.154.12\r\n', '2016-02-17', NULL, NULL),
(43, 'DEISI', 'CORONEL', 'HUMAN', 1, 1, '12121212', '1998-07-04', 2, 'TOCACHE', 35, '958088106', 'toledo861@hotmail.com', 1, '200.121.154.12\r\n', '2016-02-17', NULL, NULL),
(44, 'Yesica Mese ', 'MEZA', 'MEZA', 1, 1, '123123445', '0000-00-00', 1, 'Jr. mesa 538', 35, '949684193', 'toledo861@hotmail.com', 1, '201.240.89.204\r\n', '2016-02-19', NULL, NULL),
(45, 'Magaly', 'Chota', 'Chota', 1, 1, '45454545', '0000-00-00', 1, 'jr. chota 560', 35, '9496841932', 'toledo861@hotmail.com', 1, '201.240.89.204\r\n', '2016-02-19', NULL, NULL),
(46, 'MANUEL CORRALES', 'GYM', '', 1, 1, '00000000', '1990-11-20', 1, '', 38, '', '', 1, 'TENORIO', '2016-02-19', NULL, NULL),
(47, 'Frank Pucallpa', 'Pucallpa', 'Pucallpa', 1, 1, '45454545', '0000-00-00', 1, 'pucallpa 650', 38, '993437558', 'toledo861@hotmail.com', 1, '200.106.35.83\r\n', '2016-02-19', NULL, NULL),
(48, 'Nery', 'Jaen', 'Mesa Redonda', 1, 1, '00000000', '1990-11-20', 1, 'mesa redonda', 40, '949684193', 'toledo861@hotmail.com', 1, 'GILMER', '2016-02-20', NULL, NULL),
(49, 'RICARDO', 'MAYTA', 'CHICLOTE', 1, 1, '00000000', '1990-11-20', 1, 'lima', 41, '944621519', 'ricardo1mayta@hotmail.com', 1, 'RICARDO', '2016-02-20', NULL, NULL),
(50, 'Rosmeri ', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 42, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(51, 'LILIAN', 'CORTEGANA', 'TELLO', 1, 1, '00000000', '1990-11-20', 1, 'CELENDIN', 43, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(52, 'ISADORA UMAN', '', '', 1, 1, '00000000', '1990-11-20', 1, 'CELENDIN', 44, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(53, 'MANOLO', '', '', 1, 1, '00000000', '1990-11-20', 1, 'CELENDIN', 45, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(54, 'SANDRY MONICA', '', '', 1, 1, '00000000', '1990-11-20', 1, 'MOYOBAMBA', 46, '957462908', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(55, 'EDGAR', '', '', 1, 1, '00000000', '1990-11-20', 1, 'CAJAMARCA', 47, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(56, 'YULLI', 'PIURA', 'PIURA', 1, 1, '00000000', '1990-11-20', 1, '', 48, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(57, 'ELIZABETH', '', '', 1, 1, '00000000', '1990-11-20', 1, 'CHOTA', 49, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(58, 'ELIZABEHT', '', '', 1, 1, '00000000', '1990-11-20', 1, 'CAJAMARCA', 50, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(59, 'ROXANA ', 'VASQUEZ', 'HENOSTROZA', 1, 1, '00000000', '1990-11-20', 1, '', 51, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(60, 'LEIVA BAMBAMARCA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 52, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(61, 'WILDER ESPINAL', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 53, '', '', 1, 'REYES', '2016-02-22', NULL, NULL),
(62, 'Oscar', 'Velasquez ', 'Diaz', 1, 1, '00000000', '1990-11-20', 1, 'Celendin', 54, '949684193', 'toledo861@hotmail.com', 1, 'GILMER', '2016-02-22', NULL, NULL),
(63, 'Kati', 'Vasquez', 'Malvinas', 1, 1, '00000000', '1990-11-20', 1, 'Malvinas', 55, '949684193', 'toledo861@hotmail.com', 1, 'GILMER', '2016-02-22', NULL, NULL),
(64, 'MIGUEL', 'PARI', 'AQUINO', 1, 1, '00000000', '1990-11-20', 1, 'PICHANAQUI', 56, '950454678', 'toledo861@hotmail.com', 1, 'GILMER', '2016-02-23', NULL, NULL),
(65, 'ABEL TARAPOTO', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 57, '', '', 1, 'GILMER', '2016-02-23', NULL, NULL),
(66, 'Alindor', 'Mendoza', 'Hoyos', 1, 1, '00000000', '1990-11-20', 1, 'Cajamarca', 58, '976777777', 'toledo861@hotmail.com', 1, 'GILMER', '2016-02-23', NULL, NULL),
(67, 'Brenda', 'Arce', 'Arce', 1, 1, '00000000', '1990-11-20', 1, 'mesa redonda', 59, '949684193', 'toledo861@hotmail.com', 1, 'GILMER', '2016-02-23', NULL, NULL),
(68, 'PERCY', 'LOZANO', 'LOZANO', 1, 1, '00000000', '1990-11-20', 1, 'LIMA', 60, '949684193', 'toledo861@hotmail.com', 1, 'YINER', '2016-02-24', NULL, NULL),
(69, 'OSCAR', 'Velasquez ', 'Diaz', 1, 1, '00000000', '1990-11-20', 1, 'Celendin', 61, '9496894193', 'toledo861@hotmail.com', 1, 'REYES', '2016-02-25', NULL, NULL),
(70, 'MARTIN', 'TORRES', 'RAMOS', 1, 1, '00000000', '1990-11-20', 1, 'SATIPO', 62, '', 'toledo861@hotmail.com', 1, 'GILMER', '2016-02-25', NULL, NULL),
(71, 'RICARDO', 'AQUINO ', 'LOPEZ', 1, 1, '00000000', '1990-11-20', 1, 'CAJAMARCA', 63, '', '', 1, 'RICARDO', '2016-02-26', NULL, NULL),
(72, 'LENIN MESA', 'LIMA', '', 1, 1, '00000000', '1990-11-20', 1, '', 64, '', '', 1, 'RICARDO', '2016-02-26', NULL, NULL),
(73, 'MAGNA', 'SILVESTRE', 'LOAIZA', 1, 1, '00000000', '1990-11-20', 1, 'TARMA', 65, '', '', 1, 'RICARDO', '2016-02-26', NULL, NULL),
(74, 'JHONY  FERRENAFE', '', '', 1, 1, '00000000', '1990-11-20', 1, 'MALVINAS', 66, '', '', 1, 'GILMER', '2016-02-27', NULL, NULL),
(75, 'ANITA ', 'COUYO', 'SOLIZ', 1, 1, '00000000', '1990-11-20', 1, 'Mesa Redonda 1er piso', 67, '', '', 1, 'GILMER', '2016-02-27', NULL, NULL),
(76, 'GABRIELA', '', '', 1, 1, '00000000', '1990-11-20', 1, 'LIMA', 68, '', '', 1, 'GILMER', '2016-02-27', NULL, NULL),
(77, 'MAGALY', 'DIAZ', 'VELAZQUEZ', 1, 1, '00000000', '1990-11-20', 1, 'CHOTA', 69, '', '', 1, 'GILMER', '2016-02-27', NULL, NULL),
(78, 'GILMER', 'HUAMAN ', '', 1, 1, '00000000', '1990-11-20', 1, 'LIMA', 70, '', '', 1, 'GILMER', '2016-02-28', NULL, NULL),
(79, 'ADOLFO', 'CERRON', 'CERRON', 1, 1, '00000000', '1990-11-20', 1, 'LIMA', 71, '', '', 1, 'GILMER', '2016-03-02', NULL, NULL),
(80, 'MANOLO', 'CELENDIN', 'CELENDIN', 1, 1, '00000000', '1990-11-20', 1, 'CELENDIN', 72, '', '', 1, 'GILMER', '2016-03-03', NULL, NULL),
(81, 'ALFREDO', 'CHAMARRO', 'CHAMARRO', 1, 1, '00000000', '1990-11-20', 1, '', 73, '', '', 1, 'GILMER', '2016-03-03', NULL, NULL),
(82, 'rosa ', 'leiva', '', 1, 1, '00000000', '1990-11-20', 1, '', 74, '', '', 1, 'GILMER', '2016-03-04', NULL, NULL),
(83, 'RICARDO MAITA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 75, '', '', 1, 'GILMER', '2016-03-08', NULL, NULL),
(84, 'GREGORIO', 'MANANAY', 'RODRIGUEZ', 1, 1, '00000000', '1990-11-20', 1, 'MOYOBAMABA', 76, '', '', 1, 'GILMER', '2016-03-08', NULL, NULL),
(85, 'ROSA', 'LEIVA', 'ESQUIEN', 1, 1, '00000000', '1990-11-20', 1, 'CHOTA', 77, '', '', 1, 'GILMER', '2016-03-08', NULL, NULL),
(86, 'REYES', 'HUAMAN ', 'SAUCEDO', 1, 1, '00000000', '1990-11-20', 1, '', 78, '', '', 1, 'GILMER', '2016-03-11', NULL, NULL),
(87, 'ESTEFANY LUNA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 79, '', '', 1, 'GILMER', '2016-03-15', NULL, NULL),
(88, 'z', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 80, '', '', 1, 'GILMER', '2016-03-16', NULL, NULL),
(89, 'NORVIL', 'BLANCO', 'BENAVIDES', 1, 1, '00000000', '1990-11-20', 1, 'BAMABAMARCA', 81, '', '', 1, 'GILMER', '2016-03-16', NULL, NULL),
(90, 'zzz', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 82, '', '', 1, 'GILMER', '2016-03-17', NULL, NULL),
(91, 'YENY', 'DE LA CRUZ', 'NOA', 1, 1, '00000000', '1990-11-20', 1, 'PICHANAQUI', 83, '', '', 1, 'GILMER', '2016-03-18', NULL, NULL),
(92, 'MERVIL', 'DELA CRUZ', 'NOA ', 1, 1, '00000000', '1990-11-20', 1, '', 84, '', '', 1, 'GILMER', '2016-03-18', NULL, NULL),
(93, 'RUTH', 'MAMANI', '', 1, 1, '00000000', '1990-11-20', 1, 'MESA REDONDA', 85, '', '', 1, 'GILMER', '2016-03-22', NULL, NULL),
(94, 'MARGARITA', 'MAMANI ', 'CONDORI', 1, 1, '00000000', '1990-11-20', 1, 'LIMA', 86, '', '', 1, 'GILMER', '2016-04-01', NULL, NULL),
(95, 'ALEX VASQUEZ BAMBAMA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 87, '', '', 1, 'GILMER', '2016-04-03', NULL, NULL),
(96, 'zz', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 88, '', '', 1, 'GILMER', '2016-04-03', NULL, NULL),
(97, 'MARITZA', 'TRUJILLO ALVARADO', '', 1, 1, '00000000', '1990-11-20', 1, '', 89, '', '', 1, 'GILMER', '2016-04-05', NULL, NULL),
(98, 'MILAGROS', 'REINA ', 'MOSQUEDA', 1, 1, '00000000', '1990-11-20', 1, 'IQUITOS', 90, '', '', 1, 'GILMER', '2016-04-06', NULL, NULL),
(99, 'ALEX ', 'COPA ', 'MAMANI', 1, 1, '00000000', '1990-11-20', 1, 'TRUJILLO', 91, '', '', 1, 'GILMER', '2016-04-07', NULL, NULL),
(100, 'JHOEL BAMBAMARCA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 92, '', '', 1, 'GILMER', '2016-04-19', NULL, NULL),
(101, 'JOSÃ‰ LUIS', 'RAMOS', 'RAMOS', 1, 1, '00000000', '1990-11-20', 1, 'PANGOA', 93, '', '', 1, 'GILMER', '2016-04-22', NULL, NULL),
(102, 'MARLLINI ', 'VASQUEZ', 'HENOSTROZA', 1, 1, '00000000', '1990-11-20', 1, 'HUARAZ', 94, '', '', 1, 'GILMER', '2016-04-26', NULL, NULL),
(103, 'YINER', 'TOLEDO', '', 1, 1, '00000000', '1990-11-20', 1, '', 95, '', '', 1, 'GILMER', '2016-04-29', NULL, NULL),
(104, 'DANY MESA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 96, '', '', 1, 'GILMER', '2016-04-30', NULL, NULL),
(105, 'irma ', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 97, '', '', 1, 'GILMER', '2016-05-04', NULL, NULL),
(106, 'ADELIA HUAMAN ', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 98, '', '', 1, 'GILMER', '2016-05-04', NULL, NULL),
(107, 'WILDER BAMBAMARCA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 99, '', '', 1, 'GILMER', '2016-05-04', NULL, NULL),
(108, 'OSCAR HUAMAN', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 100, '', '', 1, 'GILMER', '2016-05-07', NULL, NULL),
(109, 'RUDY BRIONES DIAS', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 101, '', '', 1, 'GILMER', '2016-05-10', NULL, NULL),
(110, 'DANTE', 'HOYOS', '', 1, 1, '00000000', '1990-11-20', 1, 'LIMA', 102, '', '', 1, 'GILMER', '2016-05-24', NULL, NULL),
(111, 'OSCAR HUAMAN SAUCEDO', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 103, '', '', 1, 'GILMER', '2016-06-10', NULL, NULL),
(112, 'ROXANA HENOSTROZA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 104, '', '', 1, 'GILMER', '2016-07-02', NULL, NULL),
(113, 'EDELMIRA', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 105, '', '', 1, 'GILMER', '2016-07-02', NULL, NULL),
(114, 'MARI ABANTO', '', '', 1, 1, '00000000', '1990-11-20', 1, '', 106, '', '', 1, 'GILMER', '2016-08-05', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_privilegios`
--

CREATE TABLE `sm_privilegios` (
  `PRI_C_CODIGO` int(11) NOT NULL,
  `PRI_C_NOMBRE` varchar(25) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_productos`
--

CREATE TABLE `sm_productos` (
  `PRO_C_CODIGO` int(11) NOT NULL,
  `PRO_D_NOMBRE` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `PRO_D_MODELO` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `PRO_D_DESCRIPCION` varchar(700) CHARACTER SET utf8 COLLATE utf8_spanish2_ci DEFAULT NULL,
  `CAT_C_CODIGO` int(11) DEFAULT NULL,
  `MAR_C_CODIGO` int(11) DEFAULT NULL,
  `PV_C_CODIGO` int(11) NOT NULL,
  `PRO_I_IMAGEN` varchar(200) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `PRO_N_CANTIDAD` decimal(8,2) DEFAULT NULL,
  `PRO_N_PRECIOCOMPRA` decimal(8,2) DEFAULT NULL,
  `PRO_N_PRECIOVENTA` decimal(8,2) NOT NULL,
  `PRO_N_DESCUENTO` decimal(8,2) NOT NULL,
  `PRO_N_MINVENTA` int(11) NOT NULL,
  `AUD_F_FECHAINSERCION` date DEFAULT NULL,
  `AUD_U_USARIOCREA` int(11) DEFAULT NULL,
  `AUD_F_FECHAMODIFICACION` date DEFAULT NULL,
  `AUD_U_USARIOMOFICIA` int(11) DEFAULT NULL,
  `PRO_E_ESTADO` char(2) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `SED_C_CODIGO` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_productos`
--

INSERT INTO `sm_productos` (`PRO_C_CODIGO`, `PRO_D_NOMBRE`, `PRO_D_MODELO`, `PRO_D_DESCRIPCION`, `CAT_C_CODIGO`, `MAR_C_CODIGO`, `PV_C_CODIGO`, `PRO_I_IMAGEN`, `PRO_N_CANTIDAD`, `PRO_N_PRECIOCOMPRA`, `PRO_N_PRECIOVENTA`, `PRO_N_DESCUENTO`, `PRO_N_MINVENTA`, `AUD_F_FECHAINSERCION`, `AUD_U_USARIOCREA`, `AUD_F_FECHAMODIFICACION`, `AUD_U_USARIOMOFICIA`, `PRO_E_ESTADO`, `SED_C_CODIGO`) VALUES
(1, 'NOKIA ', 'NOKIA106', 'TamaÃ±o de la pantalla: 1,8 pulg\r\nResoluciÃ³n de pantalla: QQVGA (160 x 128) \r\nColores de pantalla: HighColor (16-bit/64k) \r\nTecnologÃ­a de pantalla: LCD de transmisiÃ³n \r\nDensidad de pixeles: 114 ppi\r\n', 1, 41, 1, 'nokia_106.png', '0.00', '0.00', '0.00', '0.01', 5, '2015-05-18', 1, '2015-05-29', 190234, '0', 1),
(2, 'ALCATEL ', 'ALCATEL3020', 'Wi-Fi: Wi-Fi 802.11 b/g/n\r\nBluetooth: 3.0 A2DP\r\nMicro USB: v2.0\r\nTarjeta Micro SD: hasta 16 GB\r\nCodificador de voz: AMR/EFR/FR/HR\r\nOtros: SIM dual SIM dual en espera  se GPRS 12,Enlace ', 1, 4, 1, 'Alcatel_3020.jpg', '0.00', '0.00', '0.00', '0.00', 4, '2015-05-18', 1, '2015-05-26', 2, '0', 1),
(3, 'SANSUNG S3 MINI', 'SANSUNG S3 MINI', 'El Samsung Galaxy S III mini es una versiÃ³n menor del Samsung Galaxy S III, pantalla Super AMOLED WVGA de 4 pulgadas, cÃ¡mara de 5 megapixels, procesador dual-core a 1GHz, 1GB de RAM, conectividad 3G, 8/16GB de almacenamiento interno y NFC y corre Android 4.1 Jelly Bean.', 1, 52, 1, 'Sansung_s3.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-18', 1, '2015-07-12', 2, '0', 1),
(4, 'NOKIA ', 'NOKIA 220', 'El Nokia 220 es un ultra bÃ¡sico telÃ©fono celular de bajo costo, con una pantalla de 2.4 pulgadas a 240 x 320 pixels de resoluciÃ³n, cÃ¡mara de 2 megapixels, ranura microSD, radio FM Stereo, y baterÃ­a de 1100mAh.', 1, 41, 1, 'nokia 106.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 1, NULL, NULL, '0', 1),
(5, 'NOKIA ', 'NOKIA 220', 'El Nokia 220 es un ultra bÃ¡sico telÃ©fono celular de bajo costo, con una pantalla de 2.4 pulgadas a 240 x 320 pixels de resoluciÃ³n, cÃ¡mara de 2 megapixels, ranura microSD, radio FM Stereo, y baterÃ­a de 1100mAh.', 1, 41, 1, 'Nokia-220.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 1, '2016-02-08', 2, '0', 1),
(6, 'LANIX ', 'LANIX 106', 'Android 4.4  Kit Kat\r\nProcesador MTK6572M Dual Core, 1.0Ghz\r\nCÃ¡mara de 5Mpx con Flash LED\r\nBluetooth 4.0\r\nWiFi 802.11n\r\n', 1, 32, 1, 'lanix_s130.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 1, '2015-05-27', 190234, '0', 1),
(7, 'NOKIA 210', 'NOKIA 210', 'El Nokia Asha 210 es un telÃ©fono celular con teclado QWERTY fÃ­sico que ofrece rÃ¡pido acceso a Facebook o WhatsApp segÃºn regiÃ³n y estÃ¡ destinado a competir con BlackBerry. Se trata de un Series 40 con una pantalla QVGA de 2.4 pulgadas, cÃ¡mara de 2 megapixels, Wi-Fi, radio FM y ranura microSD.', 1, 41, 1, 'Nokia-asha-210.jpg', '0.00', '0.00', '0.00', '0.00', 2, '2015-05-18', 1, '2015-07-12', 2, '0', 1),
(8, 'NOKIA 303', 'NOKIA 303', 'El Nokia Asha 303 es un telÃ©fono celular GSM con teclado QWERTY y pantalla touchscreen QVGA de 2.6 pulgadas. Destinado a mercados emergentes, el Asha 303 posee cÃ¡mara de 3.2 megapixels, ranura microSD, Bluetooth Stereo y Radio FM.', 1, 41, 1, 'Nokia-303-asha.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 1, '2015-07-12', 2, '0', 1),
(9, 'OWN F1010', 'OWN F1010', '', 1, 30, 1, 'onwf1010.jpg', '0.00', '43.00', '50.00', '0.00', 1, '2015-05-18', 1, '2016-05-24', 190233, '1', 1),
(10, 'CHIPS MOVISTAR', 'CHIPS MOVISTAR', 'Chip Movistar 4G lte', 3, 56, 1, 'chip_movistar_4g.jpg', '18.00', '1.00', '0.60', '0.00', 0, '2015-05-18', 2, '2016-08-06', 181233, '1', 1),
(11, 'Nokia 530', 'Nokia 530', 'El Nokia Lumia 530 es el smartphone Windows Phone mÃ¡s econÃ³mico a la fecha. Posee una pantalla de 4 pulgadas a 854 x 480 pixels de resoluciÃ³n, procesador Qualcomm Snapdragon 200 quad-core a 1.2GHz, 512MB de RAM, 4GB de almacenamiento, cÃ¡mara trasera de 5 megapixels y corre Windows Phone 8.1.', 1, 41, 1, 'nokia_530.jpg', '0.00', '0.00', '0.00', '0.03', 0, '2015-05-18', 2, '2016-02-08', 2, '0', 1),
(12, 'Nokia Lumia 630', ' Lumia 630', 'El Nokia Lumia 630 es el nuevo smartphone econÃ³mico de Nokia, esta vez corriendo Windows Phone 8.1. Posee una pantalla FWVGA de 4.5 pulgadas con protecciÃ³n Gorilla Glass 3, procesador Qualcomm Snapdragon 400 quad-core a 1.2GHz, 512MB de RAM, 8GB de almacenamiento interno, y ranura microSD expandible hasta 128GB.', 1, 41, 1, 'nokia_630.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-02-08', 2, '0', 1),
(13, 'Samsung  Pocket 2', 'Galaxy Pocket 2', 'El Samsung Galaxy Pocket 2 es el sucesor del Galaxy Pocket original,  pantalla HVGA de 3.3 pulgadas, cÃ¡mara de 2 megapixels, y 4GB de almacenamiento, \r\nColor:BLANCO', 1, 41, 1, 'sansun_poke_2_b.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2015-05-19', 2, '0', 1),
(14, ' Samsung G. Pocket 2', ' Galaxy Pocket 2', 'El Samsung Galaxy Pocket 2 es el sucesor del Galaxy Pocket original, manteniendo las mÃ¡s bajas especificaciones posibles, como una pantalla HVGA de 3.3 pulgadas, cÃ¡mara de 2 megapixels, y 4GB de almacenamiento, pero corriendo esta vez Android 4.4 KitKat. COLOR: NEGRO', 1, 41, 1, 'sansun_poke_2_n.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, NULL, NULL, '0', 1),
(15, 'Nokia Asha 311', 'NOKIA   311', 'El Nokia Asha 311 es un telÃ©fono celular GSM con soporte HSDPA, con una pantalla touchscreen de 3 pulgadas, cÃ¡mara de 3.2 megapixels, procesador de 1GHz, GPS, y ranura microSD.', 1, 41, 1, 'nokia_ASHA_311.jpg', '0.00', '200.00', '210.00', '0.00', 0, '2015-05-18', 2, '2016-02-08', 2, '0', 1),
(16, 'SAMSUNG S4 Mini', 'SAMSUNG S4 Mini', 'COLOR:BLANCO', 1, 52, 1, 'sansung_s4_mini.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-03-19', 2, '1', 1),
(17, 'Samsung  S4 mini', 'Galaxy S4 mini', 'El Samsung Galaxy S4 mini : Posee una pantalla Super AMOLED qHD de 4.3 pulgadas, procesador dual-core, cÃ¡mara trasera de 8 megapixels, cÃ¡mara frontal de 1.9 MP, conectividad 3G y 4G LTE y corre Android 4.2.2 Jelly Bean con la interfaz TouchWiz Nature UX 2.0.', 1, 52, 1, 'sansung_s4_MINI_N.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2015-07-12', 2, '0', 1),
(18, 'Samsung  S4 i9500', 'Galaxy S4 GT-i9500', ' procesador con 8 nÃºcleos : tiene 1.6Ghz y 2GB de RAM para alojar el Android Jelly Bean con ligereza. La pantalla Super AMOLED ha ganado casi 2 pulgadas, aumento de la resoluciÃ³n para Full HD y sigue siendo con protecciÃ³n Gorilla Glass contra araÃ±azos.\r\nLa cÃ¡mara de 13 megapÃ­xeles con flash LED ', 1, 52, 1, 'sansung_s4_i9500.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-02-08', 2, '0', 1),
(19, ' Alcatel  1035', ' One Touch 1030', 'El Alcatel One Touch 1030 es un simple telÃ©fono celular plegable, con una pantalla QQVGA de 1.8 pulgadas, radio FM, ranura microSD, y disponible en versiÃ³n SIM dual.', 1, 4, 1, 'alcatel_1030.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-02-08', 2, '0', 1),
(20, ' Motorola E', 'Moto E', 'El Motorola Moto E sigue el camino del Moto X y Moto G, adaptando de su diseÃ±o y manteniendo un bajo costo. El Moto E posee una pantalla qHD de 4.3 pulgadas, procesador Snapdragon 200 dual-core a 1.2GHz, 1GB de RAM, 4GB de almacenamiento interno, cÃ¡mara trasera de 5 megapixels, y corre Android 4.4 KitKat.', 1, 38, 1, 'motorola_moto_e.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2015-07-12', 2, '0', 1),
(21, ' LG L50', ' LG L50', 'El LG L50 es un smartphone Android KitKat con una pantalla WVGA de 4 pulgadas, procesador dual-core a 1.3GHz, cÃ¡mara de 3.2 megapixels, 4GB de almacenamiento, 512MB de RAM, y radio FM.', 1, 34, 1, 'lg_l50.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2015-07-12', 2, '0', 1),
(22, 'LG L70', 'LG L70', 'El LG L70 es parte de la nueva Series L III de smartphones Android. Posee una pantalla WVGA de 4.5 pulgadas, cÃ¡mara trasera de 5 MP o 8 MP dependiendo de la regiÃ³n, procesador Qualcomm dual-core a 1.2GHz, baterÃ­a de 2100mAh y Android 4.4 KitKat.', 1, 1, 1, 'lg_l70.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2015-06-15', 2, '0', 1),
(23, 'LG G2 mini', 'LG G2 mini', 'El LG G2 mini es la versiÃ³n mini del insignia LG G2, y cuenta con una pantalla LCD IPS de 4.7 pulgadas con resoluciÃ³n qHD, cÃ¡mara de 8 megapixels o 13 MP trasera, cÃ¡mara frontal de 1.3 megapixels, 1GB de RAM, 8GB , microSD,', 1, 34, 1, 'LG_G2_MINI.jpg', '0.00', '335.00', '400.00', '0.00', 0, '2015-05-18', 2, '2016-06-23', 19043, '1', 1),
(24, 'Motorola Moto G ', 'Motorola Moto G ', '', 1, 38, 1, 'motorola_moto_g.jpg', '0.00', '355.00', '490.00', '0.00', 0, '2015-05-18', 2, '2016-03-10', 190236, '0', 1),
(25, 'Nokia Lumia 520', 'Lumia 520', 'El Nokia Lumia 520 es el smartphone Lumia Windows Phone 8 mÃ¡s econÃ³mico a la fecha y cuenta con una pantalla IPS WVGA de 4 pulgadas, cÃ¡mara de 5 megapixels y procesador dual-core a 1GHz.', 1, 41, 1, 'nokia_520.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2015-07-12', 2, '0', 1),
(26, ' iPhone 5S', 'Apple iPhone 5S', 'El Apple iPhone 5S sucede al iPhone 5  pantalla Retina de 4 pulgadas,  TambiÃ©n incorpora un sensor de huellas dactilares en el botÃ³n de inicio, que permite incrementar la seguridad del telÃ©fono. Su cÃ¡mara conserva los 8 megapixels  ', 1, 8, 1, 'aiphone_5s.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-02-08', 2, '0', 1),
(27, 'SAMSUNG S5', 'SAMSUNG S5', '', 1, 52, 1, 'sansung_s5.jpg', '0.00', '793.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-07-28', 181233, '1', 1),
(28, ' LG L20', ' LG L20', 'El LG L20 es un sencillo smartphone Android con una pantalla de 3 pulgadas a 240 x 320 pixels de resoluciÃ³n, cÃ¡mara de 2 megapixels, procesador dual-core a 1GHz, 512MB de RAM, 4GB de almacenamiento interno, y conectividad HSDPA.', 1, 34, 1, 'lg_l20.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2015-07-12', 2, '0', 1),
(29, ' LG Optimus L7', 'LG  L7', 'El LG Optimus L7 es el smartphone mÃ¡s avanzado de la nueva serie L de LG. Posee una pantalla de 4.3 pulgadas, cÃ¡mara de 5 megapixels, Wi-Fi, Bluetooth, GPS, 512MB de RAM y ranura microSD. El Optimus L7 corre Android 4.0 Ice Cream Sandwich potenciado por un procesador de 1GHz.', 1, 34, 1, 'lg_l7.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2015-06-11', 2, '0', 1),
(30, 'Huawei  Y200', 'Huawei Ascend Y200', 'El Huawei Ascend Y200 es un smartphone Android de gama media. Posee una pantalla touchscreen de 3.5 pulgadas, camara de 3.2 megapixels con captura de video VGA, Wi-Fi, Bluetooth, GPS, conectividad HSPA, integracion con redes sociales, y ranura microSD. El Ascend Y200 corre Android 2.3 Gingerbread potenciado por un procesador de 800MHz.', 1, 26, 1, 'huawei y200.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-02-08', 2, '0', 1),
(31, 'LG L40', 'LG L40', 'El LG L40 es un bÃ¡sico smartphone Android con una pantalla de 3.5 pulgadas a 320 x 480 pixels de resoluciÃ³n, cÃ¡mara trasera de 3 megapixels, procesador dual-core a 1.2GHz, y versiones SIM dual y SIM triple, corriendo Android 4.4 KitKat.', 1, 34, 1, 'lg_l40.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, NULL, NULL, '0', 1),
(32, 'Azumi L2N ', 'Azumi L2N ', 'Azumi L2N Pantalla 1.8 pulgadas CÃ¡mara VGA Memoria 64MB M. Interna Usa MicroSD hasta 1GB  Memoria RAM\r\n64MB de RAM TecnologÃ­a 2G ademas MP3, Radio FM, entre otros.', 1, 10, 1, 'asumi_l2n.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-01-30', 1, '0', 1),
(33, 'Nokia 501', 'Nokia 501', 'El Nokia Asha 501 es un telÃ©fono celular corriendo la nueva plataforma Asha 1.0 con pantalla QVGA tÃ¡ctil de 3 pulgadas, cÃ¡mara de 3.2 megapixels, Wi-Fi, Bluetooth, radio FM y ranura microSD.', 1, 41, 1, 'nokia_501.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-18', 2, '2016-02-08', 2, '0', 1),
(34, 'NOKIA ', 'c3.00', '0.03', 1, 1, 1, 'black-box11_48.jpg', '0.00', '0.00', '0.00', '0.03', 0, '2015-05-19', 2, NULL, NULL, '0', 1),
(35, 'NOKIA ', 'c3.00', '', 1, 1, 1, 'black-box11_48.jpg', '0.00', '0.00', '0.00', '0.01', 0, '2015-05-19', 2, '2015-05-19', 2, '0', 1),
(36, 'LG L5', 'LG L5', 'El LG L5 Posee una pantalla de 4 pulgadas a 320 x 480 pixels, cÃ¡mara de 5 megapixels con flash LED, GPS, Wi-Fi, Bluetooth, soporte NFC, conectividad HSPA, y ranura microSD.', 1, 34, 1, 'lg l5.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-19', 1, '2015-07-12', 2, '0', 1),
(37, 'SAMSUNG Ace4 Lite ', 'SAMSUNG Ace4 Lite ', 'Galaxy Ace 4 con una pantalla WVGA de 4 pulgadas, procesador de 1.2GHz, 512MB de RAM, 4GB de almacenamiento interno, cÃ¡mara de 3 megapixels, y baterÃ­a de 1500 mAh, corriendo Android 4.4 KitKat.', 1, 1, 1, 'sansung  ace4 lite .jpg', '0.00', '190.00', '0.00', '0.00', 0, '2015-05-19', 1, '2016-05-12', 200121, '1', 1),
(38, 'sansung ace 4 lite ', 'sansung ace 4 lite', 'Galaxy Ace 4 con una pantalla WVGA de 4 pulgadas, procesador de 1.2GHz, 512MB de RAM, 4GB de almacenamiento interno, cÃ¡mara de 3 megapixels, y baterÃ­a de 1500 mAh, corriendo Android 4.4 KitKat.', 1, 1, 1, 'samsung_ace_4_lite.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-19', 1, NULL, NULL, '0', 1),
(39, 'OWN 3030', 'OWN 3030', 'Pantalla LCD TFT de 4 pulgadas con resoluciÃ³n WVGA (800x480)\r\nMemoria RAM de 512MB\r\nMicro SD hasta 32GB \r\nCÃ¡mara posterior de 8MP\r\nCÃ¡mara frontal de 5MP \r\nConectividad Doble SIM, Wi-Fi, GPS, Bluetooth 4.0', 1, 44, 1, 'own-1322-771529-1-catalog.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-19', 1, NULL, NULL, '0', 1),
(40, 'NOKIA 100', 'NOKIA 100', 'El Nokia 100 es un basico telefono celular de banda dual GSM. Posee una pantalla TFT de 1.8 pulgadas, Radio FM, SMS y Calendario.', 1, 1, 1, 'nokia-100.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-19', 1, '2015-05-26', 1, '0', 1),
(41, 'ALCATEL 2050', '', 'GSM 850/1900\r\nâ€¢ Pantalla TFT 2,4 240x320 pixeles 262k colores\r\nâ€¢ CÃ¡mara Digital 2 Megapixeles\r\nâ€¢ Reproductor MP3/ Radio FM/ ConexiÃ³n audio 3.5mm\r\nâ€¢ Bluetooth', 1, 1, 1, 'sm.jpg', '0.00', '0.00', '0.00', '0.00', 0, '2015-05-19', 1, '2015-05-29', 0, '0', 1),
(42, 'ALCATEL C7', 'ALCATEL C7', 'El Alcatel One Touch Pop C7 es un smartphone Android 4.2 Jelly Bean con una pantalla FWVGA de 5 pulgadas, cÃ¡mara de 5MP/8MP (segÃºn versiÃ³n), procesador quad-core a 1.3GHz, 512MB o 1GB de RAM (segÃºn versiÃ³n), 4GB de almacenamiento y ranura microSD.', 1, 4, 1, 'alcatel pop c7.jpg', '0.00', '285.00', '315.00', '0.00', 2, '2015-05-24', 2, '2016-08-02', 0, '1', 1),
(43, 'AZUMI A 50C', 'AZUMI A 50 C', 'Camara frontal 3,2MP\r\nCÃ¡mara posterior 12MP\r\nConectividad 3G\r\nMemoria interna 4GB\r\nMemoria externa hasta 32GB\r\n', 1, 10, 1, 'AZUMI_A50.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-24', 2, '2015-07-12', 2, '0', 1),
(44, 'NOKIA 630', 'NOKIA 630', 'El Nokia Lumia 530 es el smartphone Windows Phone mÃ¡s econÃ³mico a la fecha. Posee una pantalla de 4 pulgadas a Snapdragon 200 quad-core a 1.2GHz, 512MB de RAM, 4GB de almacenamiento, cÃ¡mara trasera de 5 megapixels y corre Windows Phone 8.1', 1, 41, 1, '_635_lumia_530.jpeg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-26', 1, NULL, NULL, '0', 1),
(45, 'VERYKOOL i129', 'VERYKOOL i129', 'El Verykool i129 es un simple telÃ©fono celular GSM soporta Doble  SIM . Posee una pantalla de 1.8 pulgadas, cÃ¡mara VGA, ranura microSD, reproductor MP3, radio FM y Organizador.', 1, 62, 1, 'verykool i 129-1.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-26', 2, '2015-07-12', 2, '0', 1),
(46, 'LG A395', 'LG A395', 'LG A395 de cuatro chips, cÃ¡mara radio mp3 ', 1, 34, 1, '113879921_2GG.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-26', 2, '2015-11-04', 19042, '0', 1),
(47, 'LANIX W30', 'LANIX W30', 'anix w30 caracteristicas y especificaciones (46)\r\nLanix W30 CaracterÃ­sticas (42)\r\nlanix w30 (28)\r\ncelular lanix basico \r\nLa cÃ¡mara es bÃ¡sica VGA\r\nMP3\r\n \r\n', 1, 32, 1, 'Sin tÃ­tulo-1.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-26', 2, '2015-07-17', 2, '0', 1),
(48, 'VERYKOOL ', 'VERYKOOL ', 'pantalla de 5 pulgadas y SIM dual opcional. Posee una cÃ¡mara de 5 megapixels, cÃ¡mara frontal VGA, radio FM Stereo, Wi-Fi, Bluetooth, GPS, integraciÃ³n con redes sociales y conectividad HSPA. El Verykool S757 corre \r\n', 1, 62, 1, 'verykool .jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-26', 2, '2015-05-27', 0, '0', 1),
(49, 'AIRIS ', 'AIRIS ', 'Pantalla MultiTÃ¡ctil Capacitiva 5.5\" IPS QHD 540x960\r\nCPU: Quad Core. MT6582M a 1.3 GHz. Android 4.2.2\r\nDual SIM. Memoria 1 GB+Almacenamiento 4 GB+4 GB MicroSD', 1, 1, 1, 'airis jpg.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-26', 2, '2015-05-29', 190234, '0', 1),
(50, 'VERYKOOL i316', 'VERYKOOL i316', 'El Verykool i316 es un telÃ©fono celular plegable con una pantalla de 1.8 pulgadas, cÃ¡mara VGA y radio FM.', 1, 62, 1, 'verykool-1.jpg', '0.00', '0.00', '0.00', '0.00', 4, '2015-05-26', 2, '2015-05-29', 190234, '1', 1),
(51, 'SONY M2 Aqua', 'SONY M2 Aqua', 'El Sony Xperia M2 es un smartphone Android de gama media sucesor del Xperia M, con una pantalla qHD de 4.8 pulgadas, procesador quad-core Snapdragon 400 a 1.2GHz, 4G LTE, cÃ¡mara de 8 megapixels Exmor RS, 1GB de RAM, 8GB ', 1, 56, 1, 'sony m2.jpg', '0.00', '470.00', '480.00', '0.00', 1, '2015-05-26', 2, '2016-03-19', 2, '1', 1),
(52, 'LG A270', 'LG A270', 'El LG A270 es un sencillo telÃ©fono celular GSM. Posee una pantalla color de 1.45 pulgadas, reproductor MP3, radio FM, altavoz y juegos.', 1, 34, 1, 'lg a270.jpg', '0.00', '0.00', '0.00', '0.00', 5, '2015-05-26', 2, NULL, NULL, '0', 1),
(53, 'LG A275', 'LG A275', 'Dual SIM\r\nLinterna\r\nCuatribanda GSM 850 / 900 / 1800 / 1900\r\nReproductor video\r\nRadio FM EstÃ©reo', 1, 34, 1, 'LG A275.jpg', '0.00', '82.00', '73.00', '0.00', 1, '2015-05-26', 2, '2016-04-23', 190232, '1', 1),
(54, 'HUAWEI Y330', 'HUAWEI Y330', '', 1, 1, 1, 'huawe_y330.jpg', '0.00', '160.00', '0.00', '0.00', 1, '2015-05-28', 2, '2016-04-29', 200121, '1', 1),
(55, 'ETOWUY 1272', 'ETOWUY 1272', 'Tapa del telÃ©fono barato 1.77 sc6531gsm pulgadas, gprs, whatsapp tapa de telÃ©fono ...\r\nradio cÃ¡mara mp3', 1, 1, 1, 'ETOWUAY.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-28', 2, '2015-05-28', 0, '0', 1),
(56, 'ETOWUAY', 'ETOWUAY', ' camara radio mp3 dual sim', 1, 1, 1, 'ETOWUAY1.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-28', 2, NULL, NULL, '0', 1),
(57, 'NOKIA C3', 'NOKIA C3', 'El Nokia C3 es un telÃ©fono celular econÃ³mico Series 40. Posee una pantalla QVGA de 2.4 pulgadas, Wi-Fi, cÃ¡mara de 2 megapixels y conector de auriculares de 3.5 mm. ', 1, 41, 1, 'nokia_c3_1.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-29', 2, '2015-05-29', 0, '0', 1),
(58, 'kingston 4gb', 'kingston 4gb', 'kingston 4gb', 1, 1, 1, 'MICRO_CD.jpg', '0.00', '9.30', '10.00', '0.00', 1, '2015-05-29', 2, '2016-02-23', 200121, '1', 1),
(59, 'kingston 32gb', 'kingston 16gb', 'kingston 32gb', 1, 1, 1, 'CD_16GB.jpg', '0.00', '33.50', '40.00', '0.00', 1, '2015-05-29', 2, '2016-03-24', 190236, '1', 1),
(60, 'AOC M601', 'AOC M601', 'Procesador MTK8312 Dual Core a 1.3 GHz\r\nPantalla Touch 6\" QHD IPS\r\n1GB RAM / Almacenamiento 8GB\r\nBluetooth 2.1, 3G HSPA, GPS, Camara 5MP\r\nAndroidâ„¢ 4.4 KitKat\r\nSIM ', 1, 1, 1, 'aoc.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-29', 2, NULL, NULL, '0', 1),
(61, 'AOC M601', 'AOC M601', 'Procesador MTK8312 Dual Core a 1.3 GHz\r\nPantalla Touch 6', 1, 1, 1, 'aoc.jpg', '0.00', '0.00', '0.00', '0.05', 1, '2015-05-29', 2, '2015-11-25', 2, '0', 1),
(62, 'tablet', 'tablet', '', 2, 1, 1, 'tablet1.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2015-05-29', 2, '2015-05-29', 0, '0', 1),
(63, 'LANIX  W32', 'W32', '', 1, 32, 1, 'LANIXW32.png', '0.00', '36.00', '37.00', '0.00', 1, '2016-01-28', 2, '2016-08-05', 181233, '1', 1),
(64, 'AZUMI L2Z', 'AZUMI L2Z', '', 1, 10, 1, 'AZUMI_L2Z.jpg', '0.00', '38.00', '38.00', '0.00', 1, '2016-01-28', 2, '2016-08-06', 181233, '1', 1),
(65, 'B MOBILE K350', 'B MOBILE K350', '', 1, 1, 1, 'bmobile-k350.jpg', '0.00', '47.00', '52.00', '0.00', 0, '2016-01-28', 2, '2016-07-02', 181176, '1', 1),
(66, 'ZTE Z222', 'ZTE Z222', '', 1, 66, 1, 'ZTEZ222_slider-01.jpg', '4.00', '72.50', '105.00', '0.00', 1, '2016-01-28', 2, '2016-08-06', 181233, '1', 1),
(67, ' TECHSONIC 353', 'TABLET TECHSONIC 353', '', 2, 1, 1, 'techsonic-3537-9507241-3-product.jpg', '0.00', '135.00', '140.00', '0.00', 0, '2016-01-28', 2, '2016-02-13', 2, '1', 1),
(68, 'NEUIMAGE Austin', 'NEUIMAGE Austin', '', 1, 1, 1, 'nim-400qb-1.jpg', '0.00', '115.00', '122.00', '0.00', 0, '2016-01-28', 2, '2016-05-10', 200121, '1', 1),
(69, 'NEUIMAGE S. Diego', 'NEUIMAGE S.Diego', '', 2, 1, 1, 'neuimage-san-diego-nim-600q-1.png', '0.00', '177.00', '195.00', '0.00', 1, '2016-01-28', 2, '2016-03-24', 190236, '1', 1),
(70, 'PROLINK NEO 4', 'PROLINK NEO 4', '', 1, 1, 1, 'PROLINK_NEO_4.jpg', '0.00', '43.00', '45.00', '0.00', 0, '2016-01-28', 2, '2016-08-07', 181233, '1', 1),
(71, 'SAMSUNG Ace4 Neo', 'SAMSUNG Ace4 Neo', '', 1, 52, 1, 'Sansung_GALAXY_ace4_neo.jpg', '0.00', '225.00', '243.00', '0.00', 0, '2016-01-28', 2, '2016-04-12', 190235, '1', 1),
(72, 'ETOWAY Force', 'ETOWAY Force', '', 1, 18, 1, 'Etoway_Force_v4.jpg', '34.00', '58.00', '68.00', '0.00', 0, '2016-01-28', 2, '2016-08-06', 181233, '1', 1),
(73, 'Sansung Galaxy J5', 'SANSUNG J5', 'Sansung Galaxy J5', 1, 1, 1, 'samsung-galaxy-j5.jpg', '1.00', '551.00', '660.00', '0.00', 0, '2016-01-29', 2, '2016-03-18', 190234, '0', 1),
(74, 'SKY Devices 4.0', 'SKY Devices 4.0', '', 1, 1, 1, 'sky-devices-4_0.jpg', '1.00', '205.00', '210.00', '0.00', 0, '2016-01-29', 2, '2016-07-31', 181233, '1', 1),
(75, 'LG B200a', 'LG B200a', 'LG B200a', 1, 1, 1, 'lg-b200a.jpg', '0.00', '49.00', '52.00', '0.00', 0, '2016-01-29', 2, '2016-06-23', 190234, '1', 1),
(76, 'HUAWEI G730', 'HUAWEI G730', 'HUAWEI G730', 1, 1, 1, 'Huawei_G730.jpg', '0.00', '418.00', '430.00', '0.00', 1, '2016-01-29', 2, '2016-02-15', 18166, '1', 1),
(77, 'HUAWEI G610', 'HUAWEI G610', 'HUAWEI G610', 1, 1, 1, 'huawei_g610.jpg', '0.00', '309.00', '320.00', '0.00', 1, '2016-01-29', 2, '2016-02-05', 1, '1', 1),
(78, 'MOTO E II', 'MOTO E II', 'MOTO E II', 1, 38, 1, 'Motorola-Moto-E-2.jpg', '0.00', '249.00', '250.00', '0.00', 1, '2016-01-29', 2, '2016-07-28', 181233, '1', 1),
(79, 'TABLET PRO 7', 'TABLET PRO 7', 'TABLET PRO 7', 1, 1, 1, 'tablet-pro-7-ingo.jpg', '0.00', '125.00', '140.00', '0.00', 1, '2016-01-29', 2, '2016-07-28', 181233, '1', 1),
(80, 'X3', 'X3', 'X3', 1, 1, 1, 'ADIFONOS_GENERICOS.jpg', '0.00', '128.00', '140.00', '0.00', 1, '2016-01-29', 2, '2016-03-08', 190236, '1', 1),
(81, 'BLU DASH JR', 'BLU DASH JR', 'BLU  DASH JR', 1, 1, 1, 'BLUE_DASH_JR.jpg', '0.00', '135.00', '140.00', '0.00', 1, '2016-01-29', 2, '2016-02-05', 1, '1', 1),
(82, 'HUAWEI Y360 ', 'HUAWEI Y360 ', 'HUAWEI Y360  COLOR NEGRO ', 1, 26, 1, 'Huawei-Y360-487.jpg', '0.00', '200.00', '220.00', '0.00', 1, '2016-01-29', 2, '2016-08-06', 181233, '1', 1),
(83, 'CARG. GENE', 'GENERICOS', 'CARGADORES GENERICOS ', 3, 1, 1, 'CARGARDOR_GE.jpg', '0.00', '2.50', '5.00', '0.00', 1, '2016-01-29', 2, '2016-05-25', 201240, '1', 1),
(84, 'PROTEC. VIDRIO', 'PROTEC. VIDRIO', '', 3, 1, 1, 'VIDRIOS_PROTECTOR_PANTALLA.jpg', '12.00', '3.00', '4.50', '0.00', 1, '2016-01-29', 2, '2016-08-04', 181233, '1', 1),
(85, 'AUDÃFONOS GENERICOS', 'AUDÃFONOS GENERICOS', 'AUDÃFONOS GENERICOS', 3, 1, 1, 'ADIFONOS_GENERICOS.jpg', '1.00', '7.00', '8.00', '0.00', 1, '2016-01-29', 2, '2016-07-10', 181176, '1', 1),
(86, 'CAR PULPOS', 'CARGADOR PULPOS', 'CARGADOR PULPOS', 3, 1, 1, 'PULPOS-CARGADORES.jpg', '0.00', '7.00', '9.00', '0.00', 1, '2016-01-29', 2, '2016-02-21', 200106, '1', 1),
(87, 'CARGADOR  UNIVSL', 'CARGADOR  UNIVSL', '', 3, 1, 1, 'CARGADOR_UNIVERSAL.jpg', '0.00', '2.50', '5.00', '0.00', 1, '2016-01-29', 2, '2016-08-04', 181233, '1', 1),
(88, 'PROTEC. FLIP', 'PROTEC. FLIP', '', 3, 1, 1, 'iCarbons_S-View_Flip_Cover_Brushed_Titanium_1024x1024.jpg', '0.00', '8.00', '10.00', '0.00', 1, '2016-01-29', 2, '2016-07-15', 181233, '1', 1),
(89, 'NOKIA 1020', 'NOKIA 1020', '', 1, 1, 1, 'nokia_lumia_1020.jpg', '0.00', '470.00', '550.00', '0.00', 1, '2016-01-29', 2, '2016-04-05', 190232, '1', 1),
(90, 'VERYKOOL I129', 'i129', 'El Verykool i129 es un  telÃ©fono celular GSM con soporte SIM dual. Posee una pantalla de 1.8 pulgadas, cÃ¡mara VGA, ranura microSD, reproductor MP3, radio FM y Organizador.', 1, 1, 1, 'verikool_i129.jpg', '0.00', '46.00', '47.00', '0.00', 1, '2016-01-29', 1, '2016-06-28', 190234, '1', 1),
(91, 'MOTO G III', 'MOTO G III', 'MOTO G III', 1, 38, 1, 'Moto_G_3rd_gen_press2.jpg', '0.00', '512.00', '630.00', '0.00', 1, '2016-01-30', 1, '2016-08-06', 181233, '1', 1),
(92, 'NOKIA 220', 'NOKIA 220', 'NOKIA 220', 1, 41, 1, '_nokia_220.jpg', '0.00', '131.00', '135.00', '0.00', 1, '2016-01-30', 1, '2016-07-28', 181233, '1', 1),
(93, 'CHIP CLARO ', 'CHIP CLARO', 'CHIP CLARO', 3, 1, 1, 'via_chip.png', '506.00', '0.10', '0.45', '0.00', 1, '2016-01-30', 1, '2016-08-02', 181233, '1', 1),
(94, 'OLITEC TAB A 7020', 'OLITEC TAB A 7020', 'OLITEC TAB A 7020', 2, 1, 1, 'OLITEC_A_7020.jpg', '0.00', '125.00', '135.00', '0.00', 1, '2016-01-30', 1, '2016-01-30', 200106, '1', 1),
(95, 'Sansung Galaxy J1', 'Sansung Galaxy J1', 'Sansung Galaxy J1', 1, 52, 1, 'Sansung_Galaxy_J1.jpg', '0.00', '385.00', '400.00', '0.00', 1, '2016-01-30', 1, '2016-02-09', 19043, '0', 1),
(96, 'MOTO G II', 'MOTO G II', 'MOTO G II', 1, 38, 1, 'moto_g_ii.jpg', '0.00', '425.00', '480.00', '0.00', 1, '2016-01-30', 1, '2016-07-28', 181233, '1', 1),
(97, 'B MOBILE 620', 'BMOBILE 620', 'B MOBILE 620', 1, 11, 1, 'bmobil_620.jpg', '0.00', '138.00', '147.00', '0.00', 1, '2016-01-30', 1, '2016-07-28', 181233, '1', 1),
(98, 'B MOBILE AX524', 'B MOBILE AX524', 'B MOBILE AX524', 1, 1, 1, 'B_MOVIL_AX524.png', '0.00', '130.00', '187.00', '0.00', 1, '2016-01-30', 1, '2016-05-12', 200121, '1', 1),
(99, 'BLU DASH J', 'BLUE DASH J', 'BLU DASH J', 1, 1, 1, 'BLU-Dash-J.jpg', '0.00', '135.00', '140.00', '0.00', 1, '2016-02-02', 1, '2016-02-25', 200121, '1', 1),
(100, 'NOKIA 106', 'NOKIA 106', 'NOKIA 106', 1, 41, 1, 'nokia-106-negro.jpg', '1.00', '76.00', '76.00', '0.00', 1, '2016-02-02', 1, '2016-06-16', 190234, '1', 1),
(101, 'BLU STUDIO C', 'BLU STUDIO C', 'BLU STUDIO C', 1, 15, 1, 'BLU-Studio-C-285.jpg', '0.00', '240.00', '255.00', '0.00', 1, '2016-02-02', 1, '2016-02-08', 2, '0', 1),
(102, 'ETOWAY 2010', 'ETOWAY 2010', 'ETOWAY 2010', 1, 17, 1, 'ETOWAY_2010.jpg', '6.00', '75.00', '81.00', '0.00', 1, '2016-02-02', 1, '2016-08-06', 181233, '1', 1),
(103, 'LG G3 Stylus', 'LG G3 Stylus', '\r\n', 1, 34, 1, 'LG_G3_STYLUS.jpg', '1.00', '440.00', '630.00', '0.00', 1, '2016-02-02', 1, '2016-07-28', 181233, '1', 1),
(104, 'LG G4 Stylus', 'LG G4 Stylus', '', 1, 34, 1, 'LG_G4-Stylus-1.jpg', '0.00', '575.00', '750.00', '0.00', 1, '2016-02-02', 1, '2016-04-29', 200121, '1', 1),
(105, 'ALCATEL 1045G', 'ALCATEL 10-45G', 'ALCATEL 1045G', 1, 4, 1, 'alcatel-one-touch-1045g.jpg', '0.00', '45.00', '45.00', '0.00', 1, '2016-02-02', 1, '2016-07-28', 181233, '1', 1),
(106, 'OWN F1009D', 'OWN F1009D', 'OWN F1009D', 1, 1, 1, 'f1009d_ficha.png', '0.00', '40.00', '45.00', '0.00', 1, '2016-02-02', 1, '2016-08-02', 181233, '1', 1),
(107, 'OWN F1030', 'OWN F1030', 'OWN F1030', 1, 1, 1, 'Own_F1030.png', '1.00', '75.00', '72.00', '0.00', 1, '2016-02-03', 1, '2016-08-04', 0, '1', 1),
(108, 'MOTOROLA 615', 'MOTOROLA 615', 'MOTOROLA 615', 1, 38, 1, 'motorola_615.jpg', '0.00', '169.00', '175.00', '0.00', 1, '2016-02-05', 1, '2016-02-06', 19043, '1', 1),
(109, 'ZTE Blade Lite', 'ZTE Blade Lite', 'El ZTE Blade L3 es un smartphone Android con una pantalla FWVGA de 5 pulgadas, cÃ¡mara de 8 megapixels con flash LED, procesador quad-core a 1.3GHz, 1GB de RAM, 8GB de almacenamiento interno, ', 1, 1, 1, 'images.jpg zte.jpg', '0.00', '215.00', '275.00', '0.00', 1, '2016-02-06', 2, '2016-07-28', 181233, '1', 1),
(110, 'HUAWEI Y635', 'HUAWEI Y635', '', 1, 1, 1, 'huawei y635.jpg', '0.00', '290.00', '365.00', '0.00', 1, '2016-02-08', 2, '2016-06-22', 19043, '1', 1),
(111, 'Tablet Lt-5646', 'Lt-5646', '', 1, 1, 1, 'tablet.jpg', '0.00', '205.00', '0.00', '0.00', 1, '2016-02-09', 2, '2016-05-10', 200121, '1', 1),
(112, 'SAMSUNG Ace4', 'SAMSUNG Ace4', '', 1, 1, 1, 'samsung.jpg', '0.00', '317.00', '330.00', '0.00', 1, '2016-02-09', 2, '2016-07-28', 181233, '1', 1),
(113, 'Samsung ace 4', '', '', 1, 1, 1, 'samsung.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2016-02-09', 2, NULL, NULL, '0', 1),
(114, 'LG L70', 'LG L70', '', 1, 1, 1, 'LG L70.jpg', '0.00', '380.00', '399.00', '0.00', 1, '2016-02-09', 2, '2016-07-28', 181233, '1', 1),
(115, 'NOKIA lumia 630', 'NOKIA lumia 630', 'NOKIA lumia 630', 1, 1, 1, 'Nokia-Lumia-630-hero-jpg.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2016-02-09', 2, NULL, NULL, '0', 1),
(116, 'NOKIA 603', 'NOKIA 603', '', 1, 1, 1, 'nokia-603-03.jpg', '0.00', '188.00', '0.00', '0.00', 1, '2016-02-09', 2, '2016-04-08', 0, '1', 1),
(117, 'PRO PANTALLA', 'PRO_PANTALLA', '', 1, 1, 1, 'PRO_PANTALIA.jpg', '0.00', '0.70', '1.30', '0.00', 1, '2016-02-09', 2, '2016-05-25', 201240, '1', 1),
(118, 'WOO Gemini', 'WOO Gemini', '', 1, 1, 1, 'WOO GMINI.jpg', '0.00', '198.00', '210.00', '0.00', 1, '2016-02-10', 2, '2016-03-19', 2, '1', 1),
(119, 'STUDIO C8', 'STUDIO C8', '', 1, 1, 1, 'samsung.jpg', '2.00', '200.00', '238.00', '0.00', 1, '2016-02-10', 2, '2016-07-28', 0, '1', 1),
(120, 'firce', '7024R', '', 1, 1, 1, 'alcterl firce.jpg', '0.00', '248.50', '238.00', '0.00', 1, '2016-02-10', 2, '2016-02-10', 2, '0', 1),
(121, 'SONY', 'M2', '', 1, 1, 1, 'sony m2.jpg', '0.00', '490.00', '520.00', '0.00', 1, '2016-02-10', 2, NULL, NULL, '0', 1),
(122, 'HUAWEI Y5 DUAL', 'HUAWEI Y5 DUAL', '', 1, 1, 1, 'HUWAWEY Y520.jpg', '0.00', '280.00', '315.00', '0.00', 1, '2016-02-10', 2, '2016-05-13', 190236, '1', 1),
(123, 'ALCTEL Firce', 'ALCATEL Firce', '', 1, 1, 1, 'alcterl firce.jpg', '0.00', '240.00', '260.00', '0.00', 1, '2016-02-10', 2, '2016-03-19', 2, '1', 1),
(124, 'SONY M4 Aqua', 'SONY M4 Aqua', 'Haz mÃ¡s cosas con dos potentes cÃ¡maras, resistencia al agua y una baterÃ­a de dos dÃ­as.', 1, 1, 1, 'xperia-m4-aqua-black.jpg', '0.00', '490.00', '720.00', '0.00', 1, '2016-02-10', 2, '2016-03-19', 2, '1', 1),
(125, 'ETOWAY 1272', 'ETOWAY 1272', '', 1, 1, 1, 'etoway 1272.jpg', '0.00', '75.00', '77.00', '0.00', 1, '2016-02-10', 2, '2016-08-06', 181233, '1', 1),
(126, 'NEUIMAGE Brickell', 'NEUIMAGE Brickell', '', 1, 1, 1, 'NEUMAGE BRICKELL.png', '0.00', '170.00', '240.00', '0.00', 1, '2016-02-10', 2, '2016-07-28', 181233, '1', 1),
(127, 'MOTOROLA XT910', 'MOTOROLA XT910', '', 1, 1, 1, 'MOTOROLA xt910.png', '0.00', '106.00', '0.00', '0.00', 1, '2016-02-11', 2, '2016-07-23', 181233, '1', 1),
(128, 'VERYKOOL S3502', 'VERYKOOL S3502', '', 1, 1, 1, 'verykool.jpg', '0.00', '109.00', '0.00', '0.00', 1, '2016-02-11', 2, '2016-08-07', 181233, '1', 1),
(129, 'LG L50', 'LG L50', '', 1, 1, 1, 'LG-L50.jpg', '0.00', '388.00', '0.00', '0.00', 1, '2016-02-11', 2, '2016-07-10', 181176, '1', 1),
(130, 'PROTEC. CORREA ', 'PROTEC. CORREA ', '', 1, 1, 1, 'CORREA.jpg', '0.00', '120.00', '0.00', '0.00', 1, '2016-02-11', 2, '2016-05-21', 181176, '1', 1),
(131, 'LG L3', 'LG-L3', '', 1, 1, 1, 'lG-L3.jpg', '0.00', '510.00', '0.00', '0.00', 1, '2016-02-11', 2, '2016-07-10', 181176, '1', 1),
(132, 'LG-A200', 'LG-A200', '', 1, 1, 1, 'LG-A200.jpg', '0.00', '120.00', '0.00', '0.00', 1, '2016-02-11', 2, '2016-02-23', 200121, '1', 1),
(133, 'LG A-200', 'LG A-200', '', 1, 1, 1, 'LG-A200.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2016-02-11', 2, NULL, NULL, '0', 1),
(134, 'LG A200', 'LG A200', '', 1, 1, 1, 'LG-A200.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2016-02-11', 2, NULL, NULL, '0', 1),
(135, 'VERYKOOL S4005', 'VERYKOOL S4002', '', 1, 1, 1, 'VERYKOLL S4005.jpg', '0.00', '165.00', '168.00', '0.00', 1, '2016-02-12', 2, '2016-07-28', 181233, '1', 1),
(136, 'LG MAGNA', 'LG MAGNA', '', 1, 34, 1, 'LG MAGANA.jpg', '4.00', '334.00', '0.00', '0.00', 1, '2016-02-12', 2, '2016-08-06', 181233, '1', 1),
(137, 'NOKIA 520', 'NOKIA 520', '', 1, 1, 1, 'NOKIA 520.jpg', '0.00', '130.00', '210.00', '0.00', 1, '2016-02-13', 2, '2016-08-02', 0, '1', 1),
(138, 'NOKIA 920', 'NOKIA 920', '', 1, 1, 1, 'NOKIA 920.jpg', '0.00', '253.00', '490.00', '0.00', 1, '2016-02-13', 2, '2016-07-28', 181233, '1', 1),
(139, 'SAMSUNG J1 3G', 'SAMSUNG J1', '', 1, 1, 1, 'SAMSUNG J2.png', '1.00', '290.00', '389.00', '0.00', 1, '2016-02-13', 2, '2016-08-06', 0, '1', 1),
(140, 'PROTEC LAMINAS', 'PROTEC LAMINAS', '', 1, 1, 1, 'LAMINAS.jpg', '0.00', '4.00', '0.00', '0.00', 1, '2016-02-13', 2, '2016-08-04', 181233, '1', 1),
(141, 'PROTECTOR NK220', 'PROTECTOR ', '', 1, 1, 1, 'Film-for-Nokia-220.jpg', '0.00', '1.50', '5.00', '0.00', 1, '2016-02-13', 2, '2016-02-14', 200121, '0', 1),
(142, 'BATERIAS', 'BATERIAS', '', 1, 1, 1, 'BATERIAS.jpg', '0.00', '22.00', '28.00', '0.00', 1, '2016-02-13', 2, '2016-02-14', 200121, '1', 1),
(143, 'sony e4 flee cover', 'sony e4 flee cover', '', 1, 1, 1, 'sony e4 flee cover.jpg', '0.00', '9.00', '12.00', '0.00', 1, '2016-02-13', 2, '2016-02-14', 200121, '0', 1),
(144, 'protector y625', 'protector y625', '', 1, 1, 1, 'y625.jpg', '0.00', '3.50', '5.00', '0.00', 1, '2016-02-13', 2, '2016-02-14', 200121, '0', 1),
(145, 'NOKIA 311', 'NOKIA 311', '', 1, 1, 1, 'nokia 311.jpg', '0.00', '133.00', '205.00', '0.00', 1, '2016-02-15', 2, '2016-08-06', 181233, '1', 1),
(146, 'POSH S500', 'POSH S500', '', 1, 1, 1, 'POSH S500.jpg', '0.00', '245.00', '0.00', '0.00', 1, '2016-02-15', 2, '2016-07-24', 181233, '1', 1),
(147, 'SAMSUNG J1 4G', 'Samsung J1 4g', '', 1, 1, 1, 'samsung  j1 ace 3g.jpg', '0.00', '330.00', '0.00', '0.00', 1, '2016-02-15', 2, '2016-08-06', 181233, '1', 1),
(148, 'LG F60', 'LG F60', 'LG F60', 1, 1, 1, 'MV-LG-F60-large1.jpg', '0.00', '249.00', '380.00', '0.00', 1, '2016-02-16', 1, '2016-07-28', 181233, '1', 1),
(149, 'HUAWEI P8 LITE', 'HUAWEI P8 LITE', '', 1, 1, 1, 'HUAWEY_P8_LITE.jpg', '0.00', '530.00', '760.00', '0.00', 1, '2016-02-16', 1, '2016-08-06', 181233, '1', 1),
(150, 'B MOBILE AX524 self', 'B MOBILE AX524 self', '', 1, 1, 1, 'alcterl firce.jpg', '0.00', '165.00', '0.00', '0.00', 1, '2016-02-17', 2, '2016-03-19', 2, '1', 1),
(151, 'Memoria 8G', 'Memoria 8G', '', 1, 1, 1, 'LAMINAS.jpg', '0.00', '10.72', '0.00', '0.00', 1, '2016-02-17', 2, '2016-08-04', 181233, '1', 1),
(152, 'NOKIA 630', 'NOKIA 630', '', 1, 1, 1, 'nokia 630.jpg', '0.00', '185.00', '208.00', '0.00', 1, '2016-02-19', 2, '2016-03-19', 2, '1', 1),
(153, 'B MOBILE K340', 'B MOBILE K340', '', 1, 1, 1, 'B MOBIL K340.png', '0.00', '46.00', '50.00', '0.00', 1, '2016-02-20', 2, '2016-06-29', 190234, '1', 1),
(154, 'SAMSUNG GN Plus', 'SAMSUNG G N Plus', '', 1, 1, 1, 'SAMSUNG GRAN NEO PLUS.jpg', '0.00', '325.00', '390.00', '0.00', 1, '2016-02-23', 2, '2016-06-20', 19043, '1', 1),
(155, 'SAMSUNG J5 4G', 'SAMSUNG J5 4G', '', 1, 1, 1, 'SAMSUNG J5 4G.jpg', '0.00', '555.00', '0.00', '0.00', 1, '2016-02-23', 2, '2016-08-06', 181233, '1', 1),
(156, 'usb 8', 'usb 8', '', 1, 1, 1, '61P3JoqMHML._SL1500_.jpg', '0.00', '11.00', '12.00', '0.00', 1, '2016-02-23', 2, '2016-05-25', 201240, '1', 1),
(157, 'usb 4', 'usb 4', '', 1, 1, 1, '61P3JoqMHML._SL1500_.jpg', '0.00', '10.00', '11.50', '0.00', 1, '2016-02-23', 2, '2016-05-25', 201240, '1', 1),
(159, 'DEU ANT XX', 'DEU ANT XX', '', 1, 1, 1, 'LAMINAS.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2016-02-25', 0, '2016-02-25', 0, '0', 1),
(161, 'ALCATEL 1035', 'ALCATEL 1035', 'ALCATEL 1035', 1, 4, 1, 'alcatel-onetouch-1035.jpg', '0.00', '79.00', '78.00', '0.00', 1, '2016-02-26', 2, '2016-07-12', 181176, '1', 1),
(162, 'SILLAS', 'SILLAS', 'SILLLAS', 1, 1, 1, 'sillas.jpg', '0.00', '26.00', '3.00', '0.00', 1, '2016-02-26', 1, '2016-06-08', 190235, '1', 1),
(163, 'ALCATEL 3075', 'ALCATEL 3075', '', 1, 1, 1, 'ALCATEL 3075.png', '0.00', '82.00', '0.00', '0.00', 1, '2016-02-29', 2, '2016-05-07', 190234, '1', 1),
(164, 'PROLINK 2440', 'PROLINK 2440', '', 1, 1, 1, 'SMARTPHONE-PROLINK-5.jpg', '0.00', '143.00', '160.00', '0.00', 1, '2016-03-01', 2, '2016-08-02', 181233, '1', 1),
(165, 'SAMSUNG J2', 'SAMSUNG J2', '', 1, 1, 1, 'samsung.jpg', '0.00', '455.00', '485.00', '0.00', 1, '2016-03-01', 2, NULL, NULL, '0', 1),
(166, 'SAMSUNG J2', 'SAMSUNG J2', '', 1, 1, 1, 'SAMSUNG J2.png', '0.00', '360.00', '485.00', '0.00', 1, '2016-03-01', 2, '2016-08-07', 181233, '1', 1),
(167, 'ZTE Open II', 'ZTE Open II', '', 1, 1, 1, 'open-2_946_Big_Imagen.png', '0.00', '113.00', '140.00', '0.00', 1, '2016-03-02', 2, '2016-05-07', 190234, '1', 1),
(168, 'ALCATEL 4009', 'ALCATEL 4009', '', 1, 1, 1, 'pixi-3-ot-4009_1175_Big_Imagen.png', '0.00', '124.00', '150.00', '0.00', 1, '2016-03-02', 2, '2016-05-18', 200121, '1', 1),
(169, 'HOLLOG. Advance', 'HOLLOG. Advance', '', 1, 1, 1, 'motorola_615.jpg', '0.00', '190.00', '255.00', '0.00', 1, '2016-03-03', 2, '2016-04-16', 190234, '1', 1),
(170, 'MOTO G I ', 'MOTO G I ', '', 1, 1, 1, 'motorola_615.jpg', '0.00', '355.00', '365.00', '0.00', 1, '2016-03-03', 2, NULL, NULL, '0', 1),
(171, 'SEFTON 1272', 'SEFTON 1272', '', 1, 1, 1, 'alcatel-onetouch-1035.jpg', '0.00', '75.00', '78.00', '0.00', 1, '2016-03-05', 2, '2016-05-23', 200106, '1', 1),
(172, 'HTC 626', 'HTC 626', '', 1, 1, 1, 'SAMSUNG J2.png', '3.00', '430.00', '530.00', '0.00', 1, '2016-03-05', 2, '2016-08-04', 181233, '1', 1),
(173, 'VERYKOOL 4510', 'VERYKOOL 4510', '', 1, 1, 1, 'verykool.jpg', '0.00', '184.00', '220.00', '0.00', 1, '2016-03-07', 2, '2016-06-07', 190235, '1', 1),
(174, 'SAMSUNG J7 3G', 'SAMSUNG J7 3G', '', 1, 1, 1, 'samsung.jpg', '0.00', '685.00', '850.00', '0.00', 1, '2016-03-08', 2, '2016-08-03', 181233, '1', 1),
(175, 'ALTRON TAB', 'ALTROIN TAB', '', 1, 1, 1, 'samsung.jpg', '0.00', '220.00', '250.00', '0.00', 1, '2016-03-08', 2, '2016-03-18', 190234, '1', 1),
(176, 'LANTAB ', 'LANTAB ', '', 1, 1, 1, 'motorola_615.jpg', '0.00', '215.00', '225.00', '0.00', 1, '2016-03-08', 2, '2016-03-08', 190236, '1', 1),
(177, 'TECSONIC', 'TECSONIC', '', 1, 1, 1, 'MOTOROLA xt910.png', '0.00', '150.00', '160.00', '0.00', 1, '2016-03-08', 2, '2016-03-08', 190236, '1', 1),
(178, 'ALCATEL POP 3', 'ALCATEL Pop 3', '', 1, 1, 1, 'SAMSUNG J2.png', '0.00', '295.00', '320.00', '0.00', 1, '2016-03-08', 2, '2016-07-10', 181176, '1', 1),
(179, 'YES ', 'YES', '', 1, 1, 1, 'B MOBIL K340.png', '0.00', '46.00', '50.00', '0.00', 1, '2016-03-08', 2, '2016-03-17', 190233, '1', 1),
(180, 'QUO PQ5', 'QUO PQ5', '', 1, 1, 1, 'MOTOROLA xt910.png', '0.00', '252.00', '268.00', '0.00', 1, '2016-03-09', 2, '2016-03-09', 190236, '1', 1),
(181, 'QUO P1', 'QUO P1', '', 1, 1, 1, 'B MOBIL K340.png', '0.00', '37.00', '47.00', '0.00', 1, '2016-03-09', 2, '2016-03-19', 2, '1', 1),
(182, 'WOO XL', 'WOO XL', '', 1, 1, 1, 'WOO GMINI.jpg', '0.00', '200.00', '250.00', '0.00', 1, '2016-03-10', 2, '2016-06-11', 190234, '1', 1),
(183, 'SKY 5.0Q', 'SKY 5.0Q', '', 1, 1, 1, 'MOTOROLA xt910.png', '0.00', '400.00', '420.00', '0.00', 1, '2016-03-10', 2, '2016-04-12', 190235, '1', 1),
(184, 'ETOWAY 3G', 'ETOWAY 3G', '', 1, 1, 1, 'alcterl firce.jpg', '0.00', '135.00', '145.00', '0.00', 1, '2016-03-12', 2, '2016-03-12', 190236, '1', 1),
(185, 'LG LEON', 'LG LEON', '', 1, 1, 1, 'alcterl firce.jpg', '5.00', '282.00', '380.00', '0.00', 1, '2016-03-12', 2, '2016-08-06', 181233, '1', 1),
(186, 'HUAWEI Y5', 'HUAWEI Y5', '', 1, 1, 1, 'alcterl firce.jpg', '0.00', '285.00', '315.00', '0.00', 1, '2016-03-12', 2, '2016-04-28', 200121, '1', 1),
(187, 'AVIO 3G', 'AVIO 3G', '', 1, 1, 1, 'huawei y635.jpg', '0.00', '140.00', '150.00', '0.00', 1, '2016-03-12', 2, '2016-03-17', 19043, '1', 1),
(188, 'OLITEC A7050', 'OLITEC A7050', '', 1, 1, 1, 'MOTOROLA xt910.png', '0.00', '145.00', '155.00', '0.00', 1, '2016-03-13', 2, '2016-04-07', 190232, '1', 1),
(189, 'SAMSUNG T379', 'SAMSUNG T379', 'on una ranura para tarjeta SIM, el Samsung Gravity TXT SGH-T379 permite download hasta 7,2 Mbps para la navegaciÃ³n por Internet, pero esto tambiÃ©n depende del operador mÃ³vil.\r\n\r\nEs dÃ©bil en conectividad, este terminal tiene Bluetooth VersiÃ³n 2.1 con A2DP, pero no tiene WiFi para conectarse a internet.', 1, 1, 1, 'samsung-gravity-txt.jpg', '1.00', '90.00', '105.00', '0.00', 1, '2016-03-14', 2, '2016-08-05', 181233, '1', 1),
(190, 'SAMSUNG T479', 'SAMSUNG T479', 'El Samsung T479 Gravity 3 es un telÃ©fono celular cuatribanda GSM con soporte 3G HSDPA. Posee una pantalla touchscreen, cÃ¡mara de 2 megapixels, A-GPS, integraciÃ³n con redes sociales, Bluetooth Stereo, ', 1, 1, 1, 'samsung-t479-gravity-3.jpg', '0.00', '92.50', '105.00', '0.00', 1, '2016-03-14', 2, '2016-03-19', 190234, '0', 1),
(191, 'SAMSUNG T489', 'SAMSUNG T489', 'El Samsung Gravity Q T289 es un bÃ¡sico telÃ©fono celular con teclado QWERTY fÃ­sico deslizable de costado, pantalla de 3 pulgadas, cÃ¡mara trasera de 2 megapixels, radio FM y baterÃ­a de 1000mAh.', 1, 1, 1, 'maxresdefault.jpg', '0.00', '92.50', '105.00', '0.00', 1, '2016-03-14', 2, '2016-03-19', 190234, '0', 1),
(192, 'LANIX 130', 'LANIX 130', '', 1, 1, 1, 'huawei y635.jpg', '0.00', '119.00', '125.00', '0.00', 1, '2016-03-15', 2, '2016-07-28', 181233, '1', 1),
(193, 'NOKIA 501', 'NOKIA 501', '', 1, 1, 1, 'NOKIA 501.jpg', '0.00', '135.00', '130.00', '0.00', 1, '2016-03-15', 2, '2016-06-04', 190233, '1', 1),
(194, 'ALCATEL C5', 'ALCATEL C5', '', 1, 1, 1, 'alcatel pop c5.png', '0.00', '246.00', '255.00', '0.00', 1, '2016-03-15', 2, '2016-08-01', 181233, '1', 1),
(195, 'HUAWEI Y625', 'HUAWEI Y625', '', 1, 1, 1, 'HUAWEY  Y625.jpg', '0.00', '306.00', '325.00', '0.00', 1, '2016-03-15', 2, '2016-07-28', 181233, '1', 1),
(196, 'SAMSUNG G Prime', 'SAMSUNG G Prime', '', 1, 1, 1, 'samsung.jpg', '0.00', '320.00', '490.00', '0.00', 1, '2016-03-16', 2, '2016-07-12', 181176, '1', 1),
(197, 'AIRIS TM54S', 'AIRIS TM54S', '', 1, 1, 1, 'AIRIS TM54S.jpg', '0.00', '185.00', '240.00', '0.00', 1, '2016-03-16', 2, '2016-08-04', 181233, '1', 1),
(198, 'SOLE F450', 'SOLE F450', '', 1, 1, 1, 'SOLE F450.jpg', '1.00', '114.00', '130.00', '0.00', 1, '2016-03-17', 2, '2016-05-19', 200121, '1', 1),
(199, 'AZUMI A40C', 'AZUMI A40C', '', 1, 1, 1, 'azumi a40c.jpg', '0.00', '165.00', '219.00', '0.00', 1, '2016-03-19', 2, '2016-06-21', 19043, '1', 1),
(200, 'ETOWAY C297', 'ETOWAY C297', '', 1, 1, 1, 'ETOWAY C297.jpg', '0.00', '167.00', '177.00', '0.00', 1, '2016-03-19', 2, '2016-04-01', 190236, '1', 1),
(201, 'SAMSUNG CORE 2', 'SAMSUNG CORE 2', '', 1, 1, 1, 'SAMSUNG CORE 2.jpg', '0.00', '300.00', '350.00', '0.00', 1, '2016-03-20', 2, '2016-08-05', 0, '1', 1),
(202, 'VERYKOLL S3503', 'VERYKOLL S3503', '', 1, 1, 1, 'VERYKOLL S3503.jpg', '5.00', '127.00', '133.00', '0.00', 1, '2016-03-21', 2, '2016-08-06', 181233, '1', 1),
(203, 'LOGIC M1', 'LOGIC M1', '', 1, 1, 1, 'LOGIC M1.jpg', '0.00', '47.00', '55.00', '0.00', 1, '2016-03-22', 2, '2016-08-02', 181233, '1', 1),
(204, 'AIRIS TM55SM', 'AIRIS TM55SM', '', 1, 1, 1, 'AIRIS TM55SM.jpg', '0.00', '200.00', '250.00', '0.00', 1, '2016-03-22', 2, '2016-04-29', 200121, '1', 1),
(205, 'LEGEND ISWAG', 'LEGEND ISWAG', '', 1, 1, 1, 'LEGEND ISWAG.png', '0.00', '190.00', '250.00', '0.00', 1, '2016-03-22', 2, '2016-08-02', 181233, '1', 1),
(206, 'LG Spirit', 'LG Spirit', '', 1, 1, 1, 'LG Spirit.jpg', '0.00', '330.00', '380.00', '0.00', 1, '2016-03-23', 2, '2016-08-02', 181233, '1', 1),
(207, 'OWN FUN', 'OWN FUN', '', 1, 1, 1, 'OWN FUN.jpg', '0.00', '228.00', '238.00', '0.00', 1, '2016-03-29', 2, '2016-04-13', 190235, '1', 1),
(208, 'AZUMI L3GA', 'AZUMI L3GA', '', 1, 1, 1, 'AZUMI L3GA.jpg', '0.00', '68.00', '78.00', '0.00', 1, '2016-04-01', 2, '2016-05-14', 190236, '1', 1),
(209, 'NOKIA 822', 'NOKIA 822', '', 1, 1, 1, 'NOKIA 822.jpg', '0.00', '203.00', '330.00', '0.00', 1, '2016-04-01', 2, '2016-07-28', 181233, '1', 1),
(210, 'ZTE KISS II', 'ZTE KISS II', '', 1, 1, 1, 'images.jpg zte.jpg', '0.00', '199.00', '130.00', '0.00', 1, '2016-04-01', 2, '2016-05-20', 201240, '1', 1),
(211, 'LG Bello', 'LG Bello', '', 1, 1, 1, 'LG Bello.jpg', '2.00', '326.00', '350.00', '0.00', 1, '2016-04-01', 2, '2016-08-04', 0, '1', 1),
(212, 'HUAWEY Y3 DUAL ', 'HUAWEY Y3 DUAL ', '', 1, 1, 1, 'HUAWEY Y3 DUAL.jpg', '0.00', '198.00', '110.00', '0.00', 1, '2016-04-01', 2, '2016-08-04', 181176, '1', 1),
(213, 'NOKIA 635', 'NOKIA 635', '', 1, 1, 1, 'nokia 311.jpg', '0.00', '199.00', '0.00', '0.00', 1, '2016-04-03', 2, '2016-07-28', 181233, '1', 1),
(214, 'NOKIA 530', 'NOKIA 530', '', 1, 1, 1, 'NOKIA 530.jpg', '0.00', '129.00', '0.00', '0.00', 1, '2016-04-03', 2, '2016-07-01', 190234, '1', 1),
(215, 'GÂ´FIVE G5', 'GÂ´FIVE G5', '', 1, 1, 1, 'GÂ´FIVE G5.jpg', '0.00', '153.00', '165.00', '0.00', 1, '2016-04-06', 2, '2016-04-30', 200121, '1', 1),
(216, 'VERYKOOL S5020', 'VERYKOOL S5020', '', 1, 1, 1, 'VERYKOOL S5020.jpg', '0.00', '277.50', '290.00', '0.00', 1, '2016-04-06', 2, '2016-04-14', 190234, '1', 1),
(217, 'MEMORIA 4 GB', 'MEMORIA 4 GB', '', 1, 1, 1, 'GÂ´FIVE G5.jpg', '0.00', '9.38', '20.00', '0.00', 1, '2016-04-07', 2, '2016-08-04', 181233, '1', 1),
(218, 'MEMORIA 16 GB', 'MEMORIA 16 GBB', '', 1, 1, 1, 'GÂ´FIVE G5.jpg', '0.00', '9.00', '20.00', '0.00', 1, '2016-04-07', 2, '2016-05-25', 201240, '1', 1),
(219, 'USB 8 GB', 'USB 8 GB', '', 1, 1, 1, 'GÂ´FIVE G5.jpg', '0.00', '11.90', '12.50', '0.00', 1, '2016-04-07', 2, '2016-08-04', 181233, '1', 1),
(220, 'ADAPTADORES ', 'ADAPTADORES ', '', 1, 1, 1, 'LG Bello.jpg', '0.00', '1.20', '2.00', '0.00', 1, '2016-04-07', 2, NULL, NULL, '1', 1),
(221, 'PCD 775', 'PCD 775', '', 1, 1, 1, 'PCD 775.jpg', '0.00', '50.00', '71.00', '0.00', 1, '2016-04-07', 2, '2016-07-28', 181233, '1', 1),
(222, 'NEUIMAGE MALIBU', 'NEUIMAGE MALIBU', '', 1, 1, 1, 'NEUIMAGE MALIBU.jpg', '0.00', '160.00', '175.00', '0.00', 1, '2016-04-07', 2, '2016-06-03', 190233, '1', 1),
(223, 'MAXWEST VICE', 'MAXWEST VICE', '', 1, 1, 1, 'MAXWEST VICE.jpg', '0.00', '115.00', '130.00', '0.00', 1, '2016-04-09', 2, '2016-07-28', 181233, '1', 1),
(224, 'NOKIA MICROSO0FT 532', 'NOKIA MICROSO0FT 532', '', 1, 1, 1, 'lumia 532.png', '0.00', '210.00', '220.00', '0.00', 1, '2016-04-12', 2, NULL, NULL, '1', 1),
(225, 'NOKIA MICROSOFT 535', 'NOKIA MICROSOFT 535', '', 1, 1, 1, 'Lumia_535_hero_green.jpg', '0.00', '310.00', '330.00', '0.00', 1, '2016-04-12', 2, NULL, NULL, '1', 1),
(226, 'ALCATEL 1052', 'ALCATEL 1052', '', 1, 1, 1, 'alcatel 1052.jpg', '0.00', '42.00', '53.00', '0.00', 1, '2016-04-12', 2, '2016-08-07', 181233, '1', 1),
(227, 'NOKIA 503', 'NOKIA 503', '', 1, 1, 1, 'NOKIA 503.jpg', '0.00', '120.00', '130.00', '0.00', 1, '2016-04-13', 2, '2016-04-13', 190235, '1', 1),
(228, 'NOKIA 535', 'NOKIA 535', '', 1, 1, 1, 'NOKIA 535.jpg', '0.00', '310.00', '330.00', '0.00', 1, '2016-04-13', 2, '2016-04-25', 19043, '1', 1),
(229, 'NOKIA 532', 'NOKIA 532', '', 1, 1, 1, 'NOKIA 532.jpg', '0.00', '210.00', '230.00', '0.00', 1, '2016-04-13', 2, '2016-04-27', 190236, '1', 1),
(230, 'OWN F2020D', 'OWN F2020D', '', 1, 1, 1, 'OWN F2020D.png', '0.00', '90.00', '110.00', '0.00', 1, '2016-04-15', 2, '2016-04-19', 190234, '1', 1),
(231, 'OWN F1015D', 'OWN F1015D', '', 1, 1, 1, 'OWN F1015D.jpg', '0.00', '75.00', '108.00', '0.00', 1, '2016-04-15', 2, '2016-08-05', 181233, '1', 1),
(232, 'OLITEC C55', 'OLITEC C55', '', 1, 1, 1, 'OLITEC C55.jpg', '0.00', '200.00', '215.00', '0.00', 1, '2016-04-16', 2, '2016-04-17', 190234, '1', 1),
(233, 'BITEL B8410', 'BITEL B8410', '', 1, 1, 1, 'BITEL B8410.png', '1.00', '150.00', '165.00', '0.00', 1, '2016-04-16', 2, '2016-05-28', 190235, '1', 1),
(234, 'VERYKOLL i240', 'VERYKOLL i240', '', 1, 1, 1, 'VERYKOLL i240.jpg', '0.00', '60.00', '70.00', '0.00', 1, '2016-04-16', 2, '2016-07-28', 181233, '1', 1),
(235, 'VERYKOLL S4003', 'VERYKOLL S4003', '', 1, 1, 1, 'VERYKOLL S4003.jpg', '2.00', '142.00', '165.00', '0.00', 1, '2016-04-16', 2, '2016-08-06', 181233, '1', 1),
(236, 'HOLLOGRAM 5034', 'HOLLOGRAM 5034', '', 1, 1, 1, 'HOLLOGRAM 5034.jpg', '1.00', '134.00', '190.00', '0.00', 1, '2016-04-16', 2, '2016-08-06', 181233, '1', 1),
(237, 'HOLLOGRAM 4206', 'HOLLOGRAM 4206', '', 1, 1, 1, 'HOLLOGRAM 4206.jpg', '0.00', '165.00', '200.00', '0.00', 1, '2016-04-16', 2, '2016-07-25', 181233, '1', 1),
(238, 'ENVIO', 'ENVIO', '', 1, 1, 1, 'e987d47001b108f20b2030da4082b185.jpg', '0.00', '400.00', '20.00', '0.00', 1, '2016-04-17', 2, '2016-08-07', 181233, '1', 1),
(239, 'IPHONE 5S', 'IPHONE 5S', '', 1, 1, 1, 'IPHONE 5S.png', '0.00', '750.00', '770.00', '0.00', 1, '2016-04-19', 2, '2016-06-25', 190234, '1', 1),
(240, 'LG LEON DUAL', 'LG LEON DUAL', '', 1, 1, 1, 'LG Spirit.jpg', '0.00', '330.00', '350.00', '0.00', 1, '2016-04-19', 2, '2016-04-19', 190234, '1', 1),
(241, 'MOTO G II DUAL', 'MOTO G II DUAL', '', 1, 1, 1, 'motorola_615.jpg', '0.00', '420.00', '435.00', '0.00', 1, '2016-04-20', 2, '2016-04-20', 190234, '1', 1),
(242, 'NOKIA C2-01', 'NOKIA C2-01', '', 1, 1, 1, 'NOKIA C2-01.jpg', '0.00', '115.00', '154.00', '0.00', 1, '2016-04-20', 2, '2016-07-28', 181233, '1', 1),
(243, 'NOKIA C1-01', 'NOKIA C1-01', '', 1, 1, 1, 'NOKIA C1-01.jpg', '0.00', '128.00', '138.00', '0.00', 1, '2016-04-20', 2, '2016-05-11', 0, '1', 1),
(244, 'NOKIA 100', 'NOKIA 100', '', 1, 1, 1, 'NOKIA 100.jpg', '0.00', '77.00', '82.00', '0.00', 1, '2016-04-21', 2, '2016-05-05', 200121, '1', 1),
(245, 'NOKIA 830', 'NOKIA 830', '', 1, 1, 1, 'NOKIA 830.jpg', '0.00', '245.00', '260.00', '0.00', 1, '2016-04-21', 2, '2016-05-27', 190235, '1', 1),
(246, 'ZTE F555', 'ZTE F555', '', 1, 1, 1, 'ZTE F555.jpg', '0.00', '77.50', '87.00', '0.00', 1, '2016-04-21', 2, '2016-05-03', 190234, '1', 1),
(247, 'WOO ORION ', 'WOO ORION ', '', 1, 1, 1, 'WOO ORION.jpg', '8.00', '180.00', '230.00', '0.00', 1, '2016-04-21', 2, '2016-08-07', 0, '1', 1),
(248, 'SONY Z3', 'ZONY Z3', '', 1, 1, 1, 'ZONY Z3.jpg', '0.00', '1280.00', '1350.00', '0.00', 1, '2016-04-23', 2, '2016-04-25', 19043, '1', 1),
(249, 'LG G3 Beat', 'LG G3 Beat', '', 1, 1, 1, 'LG G3 Beat.jpg', '0.00', '510.00', '525.00', '0.00', 1, '2016-04-23', 2, '2016-05-06', 190234, '1', 1),
(250, 'IPHONE 6S', 'IPHONE 6S', '', 1, 1, 1, 'IPHONE 6S.jpg', '0.00', '1960.00', '2250.00', '0.00', 1, '2016-04-23', 2, '2016-04-23', 190232, '1', 1),
(251, 'MOT TAPA', 'MOT TAPA', '', 1, 1, 1, 'MOT TAPA.jpg', '0.00', '140.00', '175.00', '0.00', 1, '2016-04-23', 2, '2016-04-23', 190232, '1', 1),
(252, 'ALCAT Pop 3 13mpx', 'ALCAT Pop3 13mpx ', '', 1, 1, 1, 'ALCAT POP3 13MPX.jpg', '0.00', '285.00', '350.00', '0.00', 1, '2016-04-24', 2, '2016-08-03', 181233, '1', 1),
(253, 'LG G4 C', 'LG G4 C', '', 1, 1, 1, 'LG G4 C.jpg', '1.00', '476.00', '500.00', '0.00', 1, '2016-04-24', 2, '2016-07-28', 181233, '1', 1),
(254, 'SELFIES', 'SELFIES', '', 1, 1, 1, 'SELFIES.jpg', '0.00', '8.00', '15.00', '0.00', 1, '2016-04-24', 2, '2016-08-04', 181233, '1', 1);
INSERT INTO `sm_productos` (`PRO_C_CODIGO`, `PRO_D_NOMBRE`, `PRO_D_MODELO`, `PRO_D_DESCRIPCION`, `CAT_C_CODIGO`, `MAR_C_CODIGO`, `PV_C_CODIGO`, `PRO_I_IMAGEN`, `PRO_N_CANTIDAD`, `PRO_N_PRECIOCOMPRA`, `PRO_N_PRECIOVENTA`, `PRO_N_DESCUENTO`, `PRO_N_MINVENTA`, `AUD_F_FECHAINSERCION`, `AUD_U_USARIOCREA`, `AUD_F_FECHAMODIFICACION`, `AUD_U_USARIOMOFICIA`, `PRO_E_ESTADO`, `SED_C_CODIGO`) VALUES
(255, 'SAMS POCKT NEO', 'SAMS POCKT NEO', '', 1, 1, 1, 'SAMS POCKT NEO.jpg', '0.00', '138.00', '140.00', '0.00', 1, '2016-04-25', 2, '2016-05-18', 190234, '1', 1),
(256, 'NOKIA 105', 'NOKIA 105', '', 1, 1, 1, 'nokia-106.jpg', '4.00', '78.00', '85.00', '0.00', 1, '2016-04-25', 2, '2016-08-06', 181233, '1', 1),
(257, 'LG Spirit Comb', 'LG Spirit Comb', '', 1, 1, 1, 'LG Spirit.jpg', '0.00', '305.00', '450.00', '0.00', 1, '2016-04-25', 2, '2016-05-26', 201240, '1', 1),
(258, 'CHIP BITEL', 'CHIP BITEL.jpg', '', 1, 1, 1, 'CHIP BITEL.jpg', '40.00', '0.40', '0.60', '0.00', 1, '2016-04-25', 2, '2016-08-06', 181233, '1', 1),
(259, 'ETOWAY 230', 'ETOWAY 230', '', 1, 1, 1, 'ETOWAY 230.jpg', '0.00', '68.00', '75.00', '0.00', 1, '2016-04-26', 2, '2016-07-28', 181233, '1', 1),
(260, 'LG JOY', '', '', 1, 1, 1, 'LG-Joy.jpg', '0.00', '194.00', '0.00', '0.00', 1, '2016-04-27', 2, '2016-05-25', 201240, '1', 1),
(261, 'SAMSUNG J5 3G', 'SAMSUNG J5 3G', '', 1, 1, 1, 'SAMSUNG J5 4G.jpg', '0.00', '502.00', '560.00', '0.00', 1, '2016-04-27', 2, '2016-08-06', 181233, '1', 1),
(262, 'AZUMI A50C', 'AZUMI A50C', '', 1, 1, 1, 'AZUMI A50C.jpg', '0.00', '265.00', '280.00', '0.00', 1, '2016-04-29', 2, '2016-05-07', 190234, '1', 1),
(263, 'MOTO G II ELITA ', '', '', 1, 1, 1, 'moto g 2 elita.jpg', '0.00', '427.00', '450.00', '0.00', 1, '2016-04-30', 2, '2016-07-28', 181233, '1', 1),
(264, 'LG G4C', 'LG G4C', '', 1, 1, 1, 'LG G4C ELITA.jpg', '0.00', '445.00', '470.00', '0.00', 1, '2016-04-30', 2, '2016-05-28', 181176, '1', 1),
(265, 'LG 360 ', 'LG 360', '', 1, 1, 1, 'lg-g360.jpg', '0.00', '184.50', '210.00', '0.00', 1, '2016-05-05', 2, '2016-07-28', 181233, '1', 1),
(266, 'HTC 620', 'HTC 620', '', 1, 1, 1, 'htc-desire-620.jpg', '0.00', '450.00', '0.00', '0.00', 1, '2016-05-07', 2, '2016-05-07', 190234, '1', 1),
(267, 'VERYKOL 5001', 'VERYKOL 5001', '', 1, 1, 1, 'VERYKOOL 5001.jpg', '0.00', '210.00', '215.00', '0.00', 1, '2016-05-07', 2, '2016-06-08', 190235, '1', 1),
(268, 'NOKIA 640', 'NOKIA 640', '', 1, 1, 1, 'NOKIA 640.jpg', '0.00', '345.00', '400.00', '0.00', 1, '2016-05-07', 2, '2016-07-02', 181176, '1', 1),
(269, 'MOTO E I', 'MOTO E I', '', 1, 1, 1, 'MotoE2ndGen_FrOrt_WhDevLTE_540x540zrx341dd.png', '0.00', '208.00', '225.00', '0.00', 1, '2016-05-07', 2, '2016-08-01', 181233, '1', 1),
(270, 'ETOWAY E7', 'ETOWAY E7', '', 1, 1, 1, 'ETOWAY E7.jpg', '3.00', '260.00', '280.00', '0.00', 1, '2016-05-07', 2, '2016-07-28', 0, '1', 1),
(271, 'PROLINK NEO CLIP', 'PROLINK NEO CLIP', '', 1, 1, 1, 'PROLINK NEO CLIP.jpg', '7.00', '68.00', '75.00', '0.00', 1, '2016-05-10', 2, '2016-08-06', 181233, '1', 1),
(272, 'LG L20', 'LG L20', '', 1, 1, 1, 'LG L20.jpg', '0.00', '142.00', '160.00', '0.00', 1, '2016-05-10', 2, '2016-05-10', 200121, '1', 1),
(273, 'BLU TANK II', 'BLU TANK II', '', 1, 1, 1, 'BLU TANK II.jpg', '0.00', '65.00', '70.00', '0.00', 1, '2016-05-12', 2, '2016-08-02', 181233, '1', 1),
(274, 'ALCATEL 4003', 'ALCATEL 4003', '', 1, 1, 1, 'ALCATEL 4003.jpg', '0.00', '133.00', '150.00', '0.00', 1, '2016-05-15', 2, '2016-07-28', 181233, '1', 1),
(275, 'SONY E1', 'SONY E1', '', 1, 1, 1, 'SONY E1.jpg', '0.00', '205.00', '215.00', '0.00', 1, '2016-05-18', 2, '2016-05-28', 181176, '1', 1),
(276, 'SAMSUNG J1 6', 'SAMSUNG J1 6', '', 1, 1, 1, 'SAMSUNG J1 6.jpg', '0.00', '330.00', '340.00', '0.00', 1, '2016-05-18', 2, '2016-08-01', 181233, '1', 1),
(277, 'GALAXY TAB E', 'GALAXY TAB E', '', 1, 1, 1, 'GALAXY TAB E.jpg', '0.00', '250.00', '300.00', '0.00', 1, '2016-05-21', 2, '2016-08-01', 181233, '1', 1),
(278, 'SONY E4', 'SONY E4', '', 1, 1, 1, 'SONY E4.jpg', '0.00', '330.00', '320.00', '0.00', 1, '2016-05-24', 2, '2016-06-10', 190235, '1', 1),
(279, 'HUAWEI Y520', 'HUAWEI Y520', '', 1, 1, 1, 'HUAWEY  Y520.jpg', '0.00', '215.00', '280.00', '0.00', 1, '2016-05-25', 2, '2016-06-23', 190234, '1', 1),
(280, 'SAMSUNG S3 Mini', 'SAMSUNG S3 Min', '', 1, 1, 1, 'SAMSUNG S3 Mini.jpg', '0.00', '335.00', '350.00', '0.00', 1, '2016-05-25', 2, '2016-06-08', 190235, '1', 1),
(281, 'MOTO G I', 'MOTO G I', '', 1, 1, 1, 'MOTO G I.jpg', '0.00', '295.00', '310.00', '0.00', 1, '2016-05-25', 2, '2016-06-07', 190235, '1', 1),
(282, 'LOGIC M8', 'LOGIC M8', '', 1, 1, 1, 'LOGIC M8.jpg', '1.00', '46.50', '50.00', '0.00', 1, '2016-05-26', 2, '2016-08-06', 181233, '1', 1),
(283, 'ETOWAY Z3', 'ETOWAY Z3', '', 1, 1, 1, 'ETOWAY Z3.jpg', '4.00', '165.00', '180.00', '0.00', 1, '2016-05-26', 2, '2016-06-14', 190234, '1', 1),
(284, 'SAMSUNG J7 4G', 'SAMSUNG J7 4G', '', 1, 1, 1, 'SAMSUNG J5 4G.jpg', '0.00', '725.00', '800.00', '0.00', 1, '2016-05-27', 2, '2016-08-04', 181176, '1', 1),
(285, 'LOGIC X5', 'LOGIC X5', '', 1, 1, 1, 'LOGIC X5.jpg', '0.00', '60.00', '200.00', '0.00', 1, '2016-05-29', 2, '2016-08-05', 181233, '1', 1),
(286, 'LG 360 M', 'LG 360 M', '', 1, 1, 1, 'LG L20.jpg', '0.00', '185.00', '196.50', '0.00', 1, '2016-05-31', 2, '2016-06-23', 190234, '0', 1),
(287, 'NOKIA 900', 'NOKIA 900', '', 1, 1, 1, 'NOKIA 900.jpg', '1.00', '240.00', '260.00', '0.00', 1, '2016-06-01', 2, '2016-07-28', 181233, '1', 1),
(288, 'BLU YENI TV', 'BLU YENI TV', '', 1, 1, 1, 'BLU YENI TV.jpg', '4.00', '79.00', '90.00', '0.00', 1, '2016-06-03', 2, '2016-08-05', 181233, '1', 1),
(289, 'NEUIMAGE KIDS', 'NEUIMAGE KIDS', '', 1, 1, 1, 'NEUIMAGE KIDS.jpg', '0.00', '48.00', '55.00', '0.00', 1, '2016-06-04', 2, '2016-08-04', 181176, '1', 1),
(290, 'VERYKOOLL i1211', 'VERYKOOLL i1211', '', 1, 1, 1, 'VERYKOLL i1211.jpg', '0.00', '46.00', '52.00', '0.00', 1, '2016-06-07', 2, '2016-08-06', 181233, '1', 1),
(291, 'YEZZ ANDY AC4E', 'YEZZ ANDY AC4E', '', 1, 1, 1, 'YEZZ ANDY AC4E.jpg', '0.00', '138.00', '155.00', '0.00', 1, '2016-06-09', 2, '2016-07-28', 181233, '1', 1),
(292, 'ADVANCE Th5548', 'ADVANCE Th5548', '', 1, 1, 1, 'ADVANCE Th5548.jpg', '1.00', '195.00', '215.00', '0.00', 1, '2016-06-16', 2, '2016-07-24', 181233, '1', 1),
(293, '', '', '', 1, 1, 1, 'SHARK ISWAG.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2016-06-16', 2, NULL, NULL, '0', 1),
(294, 'SHARK ISWAG', 'SHARK ISWAG', '', 1, 1, 1, 'SHARK ISWAG.jpg', '0.00', '43.00', '50.00', '0.00', 1, '2016-06-17', 2, '2016-06-17', 190234, '1', 1),
(295, 'PROLINK Neo 24', 'PROLINK Neo 24', '', 1, 1, 1, 'PROLINK Neo 24.jpg', '22.00', '58.00', '70.00', '0.00', 1, '2016-06-17', 2, '2016-08-06', 181233, '1', 1),
(296, 'SAMSUNG J1 MINI', 'SAMSUNG J1 MINI', '', 1, 1, 1, 'J1 MINI.jpg', '0.00', '208.00', '220.00', '0.00', 1, '2016-06-17', 2, '2016-06-18', 190234, '0', 1),
(297, 'B MOBILE AX675', 'B MOBILE AX675', '', 1, 1, 1, 'B MOBILE AX675.jpg', '10.00', '128.00', '135.00', '0.00', 1, '2016-06-17', 2, '2016-08-06', 181233, '1', 1),
(298, 'SAMSUNG J1 Mini', 'SAMSUNG J1 MINI', '', 1, 1, 1, 'SAMSUNG J1 Mini.jpg', '0.00', '209.00', '215.00', '0.00', 1, '2016-06-17', 2, '2016-07-28', 181233, '1', 1),
(299, 'MOBIL Go400', 'MOBIL Go400', '', 1, 1, 1, 'MOBIL Go400.jpg', '0.00', '131.00', '135.00', '0.00', 1, '2016-06-21', 2, '2016-07-28', 181233, '1', 1),
(300, 'VERYKOOL 4010', 'VERYKOOL 4010', '', 1, 1, 1, 'VERYKOOL 4010.jpg', '0.00', '172.00', '192.00', '0.00', 1, '2016-06-21', 2, '2016-08-06', 181233, '1', 1),
(301, 'VERYKOOL 4010', 'VERYKOOL 4010', '', 1, 1, 1, 'VERYKOOL 4010.jpg', '0.00', '172.00', '192.00', '0.00', 1, '2016-06-21', 2, NULL, NULL, '0', 1),
(302, 'VERYKOOL 4010', 'VERYKOOL 4010', '', 1, 1, 1, 'VERYKOOL 4010.jpg', '0.00', '172.00', '192.00', '0.00', 1, '2016-06-21', 2, NULL, NULL, '0', 1),
(303, 'VERYKOOL 4010', 'VERYKOOL 4010', '', 1, 1, 1, 'VERYKOOL 4010.jpg', '1.00', '172.00', '192.00', '0.00', 1, '2016-06-21', 2, '2016-08-06', 0, '0', 1),
(304, 'VERYKOOL 4010', 'VERYKOOL 4010', '', 1, 1, 1, 'VERYKOOL 4010.jpg', '0.00', '172.00', '192.00', '0.00', 1, '2016-06-21', 2, NULL, NULL, '0', 1),
(305, 'VERYKOOL 4010', 'VERYKOOL 4010', '', 1, 1, 1, 'VERYKOOL 4010.jpg', '0.00', '172.00', '192.00', '0.00', 1, '2016-06-21', 2, NULL, NULL, '0', 1),
(306, 'NOKIA 2760', 'NOKIA 2760', '', 1, 1, 1, 'NOKIA 2760.jpg', '0.00', '75.00', '82.00', '0.00', 1, '2016-06-21', 2, '2016-06-21', 19043, '1', 1),
(307, 'HUAWEY Y301', 'HUAWEY Y301', '', 1, 1, 1, 'HUAWEY Y301.jpg', '0.00', '130.00', '150.00', '0.00', 1, '2016-06-23', 2, '2016-07-28', 181233, '1', 1),
(308, 'B MOBIL TV280', 'B MOBIL TV280', '', 1, 1, 1, 'B MOBIL TV280.jpg', '0.00', '82.00', '90.00', '0.00', 1, '2016-06-24', 2, '2016-08-04', 181176, '1', 1),
(309, 'GO MOBILE 400', 'GO MOBILE 400', '', 1, 1, 1, 'LG G4C ELITA.jpg', '1.00', '132.00', '0.00', '0.00', 1, '2016-06-25', 2, '2016-07-28', 181233, '1', 1),
(310, 'ALCATEL 1050A', 'ALCATEL 1050A', '', 1, 1, 1, 'ALCATEL 1050A.jpg', '0.00', '42.00', '50.00', '0.00', 1, '2016-06-27', 2, '2016-08-06', 181233, '1', 1),
(311, 'HUAWEI D51', 'HUAWEI D51', '', 1, 1, 1, 'HUAWEI D51.jpg', '0.00', '55.00', '60.00', '0.00', 1, '2016-06-27', 2, '2016-07-24', 181233, '1', 1),
(312, 'YEZZ YZ500', 'YEZZ YZ500', '', 1, 1, 1, 'YEZZ YZ500.jpg', '0.00', '47.00', '52.00', '0.00', 1, '2016-06-27', 2, '2016-07-28', 181233, '1', 1),
(313, 'BITEL B8413', 'BITEL B8413', '', 1, 1, 1, 'BITEL B8413.png', '0.00', '143.00', '155.00', '0.00', 1, '2016-06-28', 2, '2016-07-28', 181233, '1', 1),
(314, 'YEZZ YZ400', 'YEZZ YZ400', '', 1, 1, 1, 'YEZZ YZ400.jpg', '0.00', '47.00', '55.00', '0.00', 1, '2016-06-28', 2, '2016-07-28', 181233, '1', 1),
(315, 'YEZZ YZ400', 'YEZZ YZ400', '', 1, 1, 1, 'YEZZ YZ400.jpg', '0.00', '47.00', '55.00', '0.00', 1, '2016-06-28', 2, NULL, NULL, '0', 1),
(316, 'LG K5', '', '', 1, 1, 1, 'lg k5.jpg', '0.00', '296.00', '315.00', '0.00', 1, '2016-06-30', 2, '2016-07-12', 181176, '1', 1),
(317, 'WOO SUPERNOVA', 'WOO SUPERNOVA', '', 1, 1, 1, 'woo supernova.jpg', '10.00', '113.00', '125.00', '0.00', 1, '2016-07-02', 2, '2016-08-06', 181233, '1', 1),
(318, 'LG K10', 'LG K10', '', 1, 1, 1, 'LG K10.jpg', '1.00', '490.00', '580.00', '0.00', 1, '2016-07-10', 2, '2016-08-05', 181233, '1', 1),
(319, 'HUAWEI Y5 II', 'HUAWEI Y5 II', '', 1, 1, 1, 'HUAWEI Y5 II.jpg', '0.00', '330.00', '360.00', '0.00', 1, '2016-07-10', 2, '2016-08-04', 181176, '1', 1),
(320, 'SMOOTH SNAP', 'SMOOTH SNAP', '', 1, 1, 1, 'SMOOTH SNAP.jpg', '24.00', '50.00', '50.00', '0.00', 1, '2016-07-10', 2, '2016-08-06', 181233, '1', 1),
(321, 'MOTO X PLay', 'MOTO X PLay', '', 1, 1, 1, 'MOTO X PLay.jpg', '0.00', '830.00', '950.00', '0.00', 1, '2016-07-10', 2, '2016-08-04', 181233, '1', 1),
(322, 'ZTE Z812', 'ZTE Z812', '', 1, 1, 1, 'ZTE Z812.jpg', '4.00', '207.00', '220.00', '0.00', 1, '2016-07-10', 2, '2016-08-06', 181233, '1', 1),
(323, 'SAMSUNG CORE PRIME', 'SAMSUNG CORE PRIME', '', 1, 1, 1, 'core prime.jpg', '1.00', '320.00', '250.00', '0.00', 1, '2016-07-12', 2, '2016-07-28', 0, '1', 1),
(324, 'VERYKOOL S354', 'VERYKOOL S354', '', 1, 1, 1, 'VERYKOOL S354.jpg', '0.00', '119.00', '129.00', '0.00', 1, '2016-07-12', 2, '2016-07-28', 181233, '1', 1),
(325, 'BITEL B8411', 'BITEL B8411', '', 1, 1, 1, 'BITEL B8410.png', '1.00', '130.00', '140.00', '0.00', 1, '2016-07-12', 2, '2016-07-28', 181233, '1', 1),
(326, 'SAMSUNG S7 Edge', 'SAMSUNG S7 Edge', '', 1, 1, 1, 'SAMSUNG S7 Edge.jpg', '0.00', '2380.00', '2500.00', '0.00', 1, '2016-07-24', 2, '2016-07-24', 181233, '1', 1),
(327, 'VERYKOOL S5005', 'VERYKOOL S5005', '', 1, 1, 1, 'VERYKOOL S5005.jpg', '0.00', '196.00', '205.00', '0.00', 1, '2016-07-24', 2, '2016-08-02', 181233, '1', 1),
(328, 'YEZZ Andy 3.5E', 'YEZZ Andy 3.5E', '', 1, 1, 1, 'YEZZ Andy 3.5E.jpg', '0.00', '120.00', '130.00', '0.00', 1, '2016-07-24', 2, '2016-07-28', 181233, '1', 1),
(329, 'PRESTAMO ', '', '', 1, 1, 1, 'ADVANCE Th5548.jpg', '0.00', '200.00', '25.00', '0.00', 1, '2016-07-24', 2, '2016-07-24', 181233, '1', 1),
(330, 'ZTE 315', 'ZTE 3', '', 1, 1, 1, 'zte 315.jpg', '0.00', '0.00', '0.00', '0.00', 1, '2016-07-25', 2, NULL, NULL, '0', 1),
(331, 'ZTE 315', 'ZTE 315', '', 1, 1, 1, 'zte 315.jpg', '2.00', '290.00', '340.00', '0.00', 1, '2016-07-25', 2, '2016-08-06', 181233, '1', 1),
(332, 'HUAWEI G8', 'HUAWEI G8', '', 1, 1, 1, 'HUAWEI G8.jpg', '0.00', '820.00', '850.00', '0.00', 1, '2016-07-28', 2, '2016-08-02', 181233, '1', 1),
(333, 'HUAWEI Eco', 'HUAWEI Eco', '', 1, 1, 1, 'HUAWEI Eco.jpg', '0.00', '265.50', '280.00', '0.00', 1, '2016-08-01', 2, '2016-08-05', 181233, '1', 1),
(334, 'LG LEON 4G', 'LG LEON 4G', '', 1, 1, 1, 'LG LEON 4G.jpg', '2.00', '287.00', '310.00', '0.00', 1, '2016-08-01', 2, '2016-08-07', 181233, '1', 1),
(335, 'HUAWEI G Play', 'HUAWEI G Play', '', 1, 1, 1, 'HUAWEI G Play.jpg', '0.00', '557.00', '580.00', '0.00', 1, '2016-08-01', 2, '2016-08-02', 181233, '1', 1),
(336, 'HUAWEI Y6Pro', 'HUAWEI Y6Pro', '', 1, 1, 1, 'HUAWEI Y6Pro.jpg', '1.00', '511.00', '0.00', '0.00', 1, '2016-08-01', 2, '2016-08-02', 181233, '1', 1),
(337, 'HUAWUEY Y6', 'HUAWEI Y6', '', 1, 1, 1, 'HUAWEI Y6.jpg', '0.00', '350.00', '380.00', '0.00', 1, '2016-08-02', 2, '2016-08-03', 181233, '1', 1),
(338, 'NEULOMAGUI 600', 'NEULOMAGUI 600', '', 1, 1, 1, 'NEULOMAGUI 600.jpg', '0.00', '200.00', '215.00', '0.00', 1, '2016-08-02', 2, '2016-08-07', 181233, '1', 1),
(339, 'MOTO G III 16', 'MOTO G III 16', '', 1, 1, 1, 'MOTO G I.jpg', '0.00', '560.00', '600.00', '0.00', 1, '2016-08-03', 2, '2016-08-03', 181233, '1', 1),
(340, 'PROLINK Neo Plus', 'PROLINK Neo Plus', '', 1, 1, 1, 'PROLINK Neo Plus.jpg', '0.00', '42.00', '50.00', '0.00', 1, '2016-08-03', 2, NULL, NULL, '1', 1),
(341, 'SMOOTH MINI', 'SMOOTH MINI', '', 1, 1, 1, 'SMOOTH SNAP.jpg', '3.00', '43.00', '47.00', '0.00', 1, '2016-08-04', 2, '2016-08-06', 181233, '1', 1),
(342, 'LAMPARA USB', 'LAMPARA USB', '', 1, 1, 1, 'LAMPARA USB.jpg', '0.00', '2.50', '5.00', '0.00', 1, '2016-08-04', 2, '2016-08-04', 181233, '1', 1),
(343, 'PROTECTOR Liga', 'PROTECTOR Liga', '', 1, 1, 1, 'PROTECTOR Liga.jpg', '0.00', '3.50', '5.00', '0.00', 1, '2016-08-04', 2, '2016-08-04', 181233, '1', 1),
(344, 'USB 64 GB', 'USB 64 GB', '', 1, 1, 1, '61P3JoqMHML._SL1500_.jpg', '1.00', '54.00', '60.00', '0.00', 1, '2016-08-04', 2, '2016-08-04', 0, '1', 1),
(345, 'LG K8', 'LG K8', '', 1, 1, 1, 'LG K8.jpg', '1.00', '425.00', '440.00', '0.00', 1, '2016-08-05', 2, '2016-08-05', 181233, '1', 1),
(346, 'LENOVO 2010', 'LENOVO 2010', '', 1, 1, 1, 'LENOVO 2010.jpg', '0.00', '206.00', '215.00', '0.00', 1, '2016-08-06', 2, '2016-08-07', 181233, '1', 1),
(347, 'LOGIC X5 CEL', 'LOGIC X5 CEL', '', 1, 1, 1, 'LOGIC X5.jpg', '1.00', '180.00', '215.00', '0.00', 1, '2016-08-07', 2, '2016-08-07', 181233, '1', 1),
(349, 'n', 'n', 'n', 1, 1, 1, 's ', '1.00', '1.00', '1.00', '1.00', 1, '2016-08-08', 2, NULL, NULL, '1', 1),
(350, 'n', 'n', 'n', 1, 1, 1, 's ', '0.00', '1.00', '1.00', '1.00', 1, '2016-08-08', 2, NULL, NULL, '1', 1),
(351, 'test ', 'tes ', 'tes ', 4, 16, 1, 'router.jpg ', '1.00', '1.00', '1.00', '1.00', 1, '2016-08-08', 0, NULL, NULL, '1', 1),
(352, 'test ', 'tes ', 'tes ', 1, 15, 1, 'depositos.png ', '1.00', '1.00', '1.00', '1.00', 1, '2016-08-08', 0, NULL, NULL, '1', 1),
(353, 'test ', 'tes ', 'tes ', 4, 17, 1, 'back.jpg ', '2.00', '2.00', '2.00', '2.00', 2, '2016-08-08', 2, NULL, NULL, '1', 1),
(354, 'test ', 'tes ', 'tes ', 4, 4, 1, 'cajadiaria.png ', '1.00', '1.00', '1.00', '1.00', 1, '2016-08-11', 2, NULL, NULL, '1', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_provedores`
--

CREATE TABLE `sm_provedores` (
  `PV_C_CODIGO` int(11) NOT NULL,
  `PV_D_NOMBRES` varchar(200) NOT NULL,
  `PV_C_DOC` varchar(11) NOT NULL,
  `PV_D_CORREO` varchar(60) NOT NULL,
  `PV_D_TELEFONO` varchar(15) NOT NULL,
  `PV_D_DIRECCION` varchar(60) DEFAULT NULL,
  `PV_E_ESTADO` int(11) DEFAULT '1',
  `SED_C_CODIGO` int(11) NOT NULL,
  `AUD_C_USUCREA` int(11) NOT NULL,
  `AUD_F_FECHACREA` date NOT NULL,
  `AUD_C_USUMOD` int(11) NOT NULL,
  `AUD_F_FECHAMOD` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `sm_provedores`
--

INSERT INTO `sm_provedores` (`PV_C_CODIGO`, `PV_D_NOMBRES`, `PV_C_DOC`, `PV_D_CORREO`, `PV_D_TELEFONO`, `PV_D_DIRECCION`, `PV_E_ESTADO`, `SED_C_CODIGO`, `AUD_C_USUCREA`, `AUD_F_FECHACREA`, `AUD_C_USUMOD`, `AUD_F_FECHAMOD`) VALUES
(1, 'JHON FERRENAFE', '0', 'referer@hotmail.com', '', 'Malvinas', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(2, 'JULIO MESA REDONDA', '0', 'ree', '', NULL, 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(3, 'LUCERO', '0', 'LUCERO@HOTMAIL.COM', '898788787', 'LIMA MESA REDONDA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(4, 'MARGARITA', '0', 'margarita@hotmail.com', '898989879', 'puno', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(5, 'WALTER PROLINK', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(6, 'LUZ MARINA CRUZ', '0', 'toledo861@hotmail.com', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(7, 'CRISTINA', '0', 'CHIS@HOTMAIL.COM', '748484785', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(8, 'FLOR TINGO MARIA', '0', '', '', 'TINGO MARIA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(9, 'ANONIMO', '0', '', '7585857', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(10, 'IVENTARIO INICIAL LI', '0', 'UTUTUTU@HOTJT.COM', '748848585', 'LIMA ', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(11, 'NICOL', '0', 'NNN@HOTMAIL.COM', '947681287', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(12, 'JUAN PABLO', '0', 'ricmaybacilon@hotmail.com', '887889', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(13, 'MARCOS', '0', '', '', 'LIMA ', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(14, 'MELVIN ETOWAY', '0', 'jilmer.emgoldex@hotmail.com', '6788876', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(15, 'SRA ALICIA', '0', 'ricmaybacilon@hotmail.com', '67488448', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(16, 'JAVIER ', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(17, 'KARINA', '0', '', '123456789', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(19, 'JESUS PELUCON', '0', '', '985264512', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(20, 'CLAUDIO MIGUEL', '0', 'ricardo@hopt.com', '565545222', 'PICHANAQUI', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(23, 'LIZETH NINO', '0', 'toledo861@hotmail.com', '943982303', 'Mesa Redonda 1er piso', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(24, 'Jian piere', '0', 'toledo861@hotmail.com', '950910045', 'Proveerdor', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(25, 'MARIA CAYAO', '0', 'toledo861@hotmail.com', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(26, 'alicia palle', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(27, 'ANITA COULLO', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(28, 'DAVID HUANCA GORDITO', '0', '', '965492060', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(29, 'JHONY CLARO', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(30, 'LENIN MESA', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(31, 'JHORDANT LEON AYALA', '0', 'toledo861@hotmail.com', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(32, 'RICHARD SICCHA', '0', '', '', 'CAJAMRCA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(33, 'NERY VECINA JAEN', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(34, 'DANTE MENDOZA', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(35, 'ESTEBAN VILCA ', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(36, 'WILI VELAJE', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(37, 'RICARDO RATON', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(38, 'ELENA MAMANI CONDORI', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(39, 'SEÃ‘ORA ELITA', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(40, 'LIDIA MARGARITA', '0', '', '', 'PUNO', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(41, 'JUANITA LOZANO', '0', '', '', 'CAJAMARCA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(42, 'JUSTO CURI JARA', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(43, 'ALINDOR MENDOZA', '0', '', '', 'CAJAMARCA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(44, 'REYES HUAMAN SAUCEDO', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(45, 'LISBET SANCHES CELEN', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(46, 'GILMER HUMAN SAUCEDO', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(47, 'ELDA BARAHONA', '0', '', '', 'CUTERVO', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(48, 'YESSICA DAZA', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(49, 'ALEX CARRANZA', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(50, 'IRMA DIAZ', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(51, 'MARIA FERNANDA', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(52, 'MANUEL CORRALES GYM', '0', '', '991316663', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(53, 'YOLANDA ', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(54, 'JUANITA MESA', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(55, 'TONY', '0', '', '', 'MESA ', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(56, 'MARLLINI', '0', '', '', 'YUNGAY', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(57, 'wilder mesa', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(58, 'MARGARITA 2', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(59, 'MARIO GUERRA', '0', '', '954982987', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(60, 'AMELIA', '0', '', '981849065', 'MAMANI', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(61, 'ROSA LEIVA', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(62, 'ABEL TARAPOTO', '0', '', '', 'TARAPOTO', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(63, 'GUSTAVO', '0', '', '', 'LIMA', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(64, 'JUSTINA ', '0', '', '', 'IQUEQUE', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(65, 'ELITA 2', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(66, 'JUSTINA 2', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(67, 'FRANCISCO MEZA', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(68, 'MANUEL2 GyM ', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00'),
(69, 'LIZBETH CELENDIN', '0', '', '', '', 1, 1, 2, '0000-00-00', 0, '0000-00-00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_provincia`
--

CREATE TABLE `sm_provincia` (
  `P_C_CODIGO` varchar(4) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `P_D_NOMBREPROVINCIA` varchar(60) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `DEP_C_CODIGO` varchar(2) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_sexo`
--

CREATE TABLE `sm_sexo` (
  `SEX_C_CODIGO` int(11) NOT NULL,
  `SEX_D_NOMBRE` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_tbcategorias`
--

CREATE TABLE `sm_tbcategorias` (
  `TEG_C_CODIGO` int(11) NOT NULL,
  `TEG_D_NOMBRE` varchar(50) NOT NULL,
  `TEG_E_ESTADO` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_tbingegre`
--

CREATE TABLE `sm_tbingegre` (
  `EIG_C_CODIGO` int(11) NOT NULL,
  `TEG_C_CODIGO` int(11) NOT NULL,
  `US_C_CODIGO` int(11) NOT NULL,
  `EIG_N_MONTO` decimal(8,2) NOT NULL,
  `EIG_F_FECHA` datetime NOT NULL,
  `EIG_E_ESTADO` int(11) NOT NULL,
  `EIG_D_OBS` varchar(100) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_tipodoc`
--

CREATE TABLE `sm_tipodoc` (
  `TD_C_CODIGO` int(11) NOT NULL,
  `TD_D_NOMBRE` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_ubigeo`
--

CREATE TABLE `sm_ubigeo` (
  `UBI_C_CODIGO` int(11) NOT NULL,
  `DEP_C_CODIGO` varchar(2) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `P_C_CODIGO` varchar(4) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `DIS_C_CODIGO` varchar(6) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_usuario`
--

CREATE TABLE `sm_usuario` (
  `US_C_CODIGO` int(11) NOT NULL,
  `PER_C_CODIGO` int(11) NOT NULL,
  `US_U_NOMUSUARIO` varchar(20) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `US_PW_PASWORD` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `PRI_C_CODIGO` int(11) NOT NULL,
  `AUD_C_USUCREA` int(11) NOT NULL,
  `AUD_F_FECHACREA` date DEFAULT NULL,
  `AUD_C_USUMOD` int(11) DEFAULT NULL,
  `AUD_F_FECHAMOD` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_utilidad`
--

CREATE TABLE `sm_utilidad` (
  `UTI_C_CODIGO` int(11) NOT NULL,
  `UTI_N_MONTO` decimal(8,2) NOT NULL,
  `UTI_F_FECHA` date NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_ventas`
--

CREATE TABLE `sm_ventas` (
  `VEN_C_CODIGO` int(11) NOT NULL,
  `US_C_CODIGO` int(11) NOT NULL,
  `CLI_C_CODIGO` int(11) NOT NULL,
  `VEN_N_TOTAL` decimal(8,2) NOT NULL,
  `VEN_N_CANCELA` decimal(8,2) NOT NULL,
  `VEN_C_NBOLETA` varchar(10) NOT NULL,
  `VEN_F_FECHA` date NOT NULL,
  `VEN_E_ESTADO` int(11) NOT NULL,
  `VEN_F_HORA` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `VEN_E_SIMPRI` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sm_vista`
--

CREATE TABLE `sm_vista` (
  `VIS_C_CODIGO` int(11) NOT NULL,
  `VIS_D_NOMBRE` varchar(100) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `VIS_E_ESTADO` int(1) DEFAULT NULL,
  `VIS_D_ALIAS` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura para la vista `dg_vista_menu`
--
DROP TABLE IF EXISTS `dg_vista_menu`;

CREATE ALGORITHM=UNDEFINED  SQL SECURITY DEFINER VIEW `dg_vista_menu`  AS  select distinct `p`.`PRM_C_CODIGO` AS `PRM_C_CODIGO`,`p`.`US_C_CODIGO` AS `US_C_CODIGO`,`v`.`VIS_C_CODIGO` AS `VIS_C_CODIGO`,`v`.`VIS_P_PADRE` AS `VIS_P_PADRE`,`v`.`VIS_D_NOMBRE` AS `VIS_D_NOMBRE`,`v`.`VIS_L_ENLACE` AS `VIS_L_ENLACE`,`v`.`VIS_I_IMG` AS `VIS_I_IMG`,`v`.`VIS_E_ESTADO` AS `VIS_E_ESTADO`,`p`.`PER_E_ESTADO` AS `PER_E_ESTADO` from (`dg_permisos` `p` join `dg_vistas` `v` on((`v`.`VIS_C_CODIGO` = `p`.`VIS_C_CODIGO`))) order by `p`.`PRM_C_CODIGO` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `dg_permisos`
--
ALTER TABLE `dg_permisos`
  ADD PRIMARY KEY (`PRM_C_CODIGO`),
  ADD KEY `fk_dg_user` (`US_C_CODIGO`),
  ADD KEY `fk_DG_VISTAS1` (`VIS_C_CODIGO`),
  ADD KEY `fk_dg_roles1` (`RO_C_CODIGO`);

--
-- Indices de la tabla `dg_roles`
--
ALTER TABLE `dg_roles`
  ADD PRIMARY KEY (`RO_C_CODIGO`);

--
-- Indices de la tabla `dg_sedes`
--
ALTER TABLE `dg_sedes`
  ADD PRIMARY KEY (`SED_C_CODIGO`);

--
-- Indices de la tabla `dg_user`
--
ALTER TABLE `dg_user`
  ADD PRIMARY KEY (`US_C_CODIGO`),
  ADD KEY `fk_dg_sedes_sed_c_odigo` (`SED_C_CODIGO`);

--
-- Indices de la tabla `dg_vistas`
--
ALTER TABLE `dg_vistas`
  ADD PRIMARY KEY (`VIS_C_CODIGO`);

--
-- Indices de la tabla `sm_capitaldia`
--
ALTER TABLE `sm_capitaldia`
  ADD PRIMARY KEY (`CAP_C_CODIGO`);

--
-- Indices de la tabla `sm_categoria`
--
ALTER TABLE `sm_categoria`
  ADD PRIMARY KEY (`CAT_C_CODIGO`);

--
-- Indices de la tabla `sm_cliente`
--
ALTER TABLE `sm_cliente`
  ADD PRIMARY KEY (`CLI_C_CODIGO`);

--
-- Indices de la tabla `sm_compra`
--
ALTER TABLE `sm_compra`
  ADD PRIMARY KEY (`C_C_CODIGO`),
  ADD KEY `FK_PV_C_CODIGO` (`PV_C_CODIGO`),
  ADD KEY `FK_us_C_CODIGO` (`US_C_CODIGO`);

--
-- Indices de la tabla `sm_cuentasCompras`
--
ALTER TABLE `sm_cuentasCompras`
  ADD PRIMARY KEY (`CC_C_CODIGO`),
  ADD KEY `FK_PV_C_CODIGO_09` (`PV_C_CODIGO`);

--
-- Indices de la tabla `sm_cuentasVentas`
--
ALTER TABLE `sm_cuentasVentas`
  ADD PRIMARY KEY (`CV_C_CODIGO`),
  ADD KEY `FK_CLI_C_CODIGO_99` (`CLI_C_CODIGO`);

--
-- Indices de la tabla `sm_departamento`
--
ALTER TABLE `sm_departamento`
  ADD PRIMARY KEY (`DEP_C_CODIGO`);

--
-- Indices de la tabla `sm_depositos`
--
ALTER TABLE `sm_depositos`
  ADD PRIMARY KEY (`DEP_C_CODIGO`);

--
-- Indices de la tabla `sm_detordenes`
--
ALTER TABLE `sm_detordenes`
  ADD PRIMARY KEY (`DTL_C_CODIGO`),
  ADD KEY `FK_PRO_C_CODIGO_01` (`PRO_C_CODIGO`),
  ADD KEY `FK_PED_C_CODIGO_01` (`ORD_C_CODIGO`);

--
-- Indices de la tabla `sm_detvista`
--
ALTER TABLE `sm_detvista`
  ADD PRIMARY KEY (`DTV_C_CODIGO`),
  ADD KEY `FK_VIS_C_CODIGO` (`VIS_C_CODIGO`),
  ADD KEY `FK_US_C_CODIGO` (`US_C_CODIGO`);

--
-- Indices de la tabla `sm_distrito`
--
ALTER TABLE `sm_distrito`
  ADD PRIMARY KEY (`DIS_C_CODIGO`),
  ADD KEY `FK_P_C_CODIGO` (`P_C_CODIGO`);

--
-- Indices de la tabla `sm_dtcompras`
--
ALTER TABLE `sm_dtcompras`
  ADD PRIMARY KEY (`COM_C_CODIGO`),
  ADD KEY `FK_C_C_CODIGO` (`C_C_CODIGO`),
  ADD KEY `FK_PRO_C_CODIGO_001` (`PRO_C_CODIGO`);

--
-- Indices de la tabla `sm_dtventas`
--
ALTER TABLE `sm_dtventas`
  ADD PRIMARY KEY (`DVE_C_CODIGO`),
  ADD KEY `FK_PRO_C_CODIGO_010` (`PRO_C_CODIGO`),
  ADD KEY `FK_VEN_C_CODIGO_010` (`VEN_C_CODIGO`);

--
-- Indices de la tabla `sm_entregas_pro`
--
ALTER TABLE `sm_entregas_pro`
  ADD PRIMARY KEY (`ENTP_C_CODIGO`),
  ADD KEY `FK_PRO_C_CODIGO` (`PRO_C_CODIGO`),
  ADD KEY `FK_CLI_C_CODIGO` (`CLI_C_CODIGO`),
  ADD KEY `FK_DTL_C_CODIGO` (`DTL_C_CODIGO`);

--
-- Indices de la tabla `sm_estadocivil`
--
ALTER TABLE `sm_estadocivil`
  ADD PRIMARY KEY (`EC_C_CODIGO`);

--
-- Indices de la tabla `sm_hisVentas`
--
ALTER TABLE `sm_hisVentas`
  ADD PRIMARY KEY (`HVE_C_CODIGO`);

--
-- Indices de la tabla `sm_imgs`
--
ALTER TABLE `sm_imgs`
  ADD PRIMARY KEY (`IMG_C_CODIGO`),
  ADD KEY `FK_imgs_C_CODIGO` (`PRO_C_CODIGO`);

--
-- Indices de la tabla `sm_ingcat`
--
ALTER TABLE `sm_ingcat`
  ADD PRIMARY KEY (`ICT_C_CODIGO`);

--
-- Indices de la tabla `sm_marca`
--
ALTER TABLE `sm_marca`
  ADD PRIMARY KEY (`MAR_C_CODIGO`);

--
-- Indices de la tabla `sm_ordenes`
--
ALTER TABLE `sm_ordenes`
  ADD PRIMARY KEY (`ORD_C_CODIGO`),
  ADD KEY `FK_CLI_C_CODIGO` (`CLI_C_CODIGO`);

--
-- Indices de la tabla `sm_pagosC`
--
ALTER TABLE `sm_pagosC`
  ADD PRIMARY KEY (`PC_C_CODIGO`),
  ADD KEY `FK_CC_C_CODIGO_07` (`CC_C_CODIGO`);

--
-- Indices de la tabla `sm_pagoscompras`
--
ALTER TABLE `sm_pagoscompras`
  ADD PRIMARY KEY (`PGC_C_CODIGO`),
  ADD KEY `FK_C_C_CODIGO050` (`C_C_CODIGO`);

--
-- Indices de la tabla `sm_pagosV`
--
ALTER TABLE `sm_pagosV`
  ADD PRIMARY KEY (`VV_C_CODIGO`),
  ADD KEY `FK_VV_C_CODIGO_097` (`CV_C_CODIGO`);

--
-- Indices de la tabla `sm_pagoventas`
--
ALTER TABLE `sm_pagoventas`
  ADD PRIMARY KEY (`PGV_C_CODIGO`);

--
-- Indices de la tabla `sm_patrimonio`
--
ALTER TABLE `sm_patrimonio`
  ADD PRIMARY KEY (`PTR_C_CODIGO`);

--
-- Indices de la tabla `sm_persona`
--
ALTER TABLE `sm_persona`
  ADD PRIMARY KEY (`PER_C_CODIGO`),
  ADD KEY `FK_PER_C_CODIGO_02` (`EC_C_CODIGO`),
  ADD KEY `FK_PER_C_CODIGO_00` (`TD_C_CODIGO`),
  ADD KEY `FK_PER_C_CODIGO_03` (`SEX_C_CODIGO`),
  ADD KEY `FK_PER_C_CODIGO_01` (`UBI_C_CODIGO`);

--
-- Indices de la tabla `sm_privilegios`
--
ALTER TABLE `sm_privilegios`
  ADD PRIMARY KEY (`PRI_C_CODIGO`);

--
-- Indices de la tabla `sm_productos`
--
ALTER TABLE `sm_productos`
  ADD PRIMARY KEY (`PRO_C_CODIGO`),
  ADD KEY `FK_MAR_C_CODIGO` (`MAR_C_CODIGO`),
  ADD KEY `FK_CAT_C_CODIGO` (`CAT_C_CODIGO`),
  ADD KEY `FK_PV_C_CODIGO` (`PV_C_CODIGO`);

--
-- Indices de la tabla `sm_provedores`
--
ALTER TABLE `sm_provedores`
  ADD PRIMARY KEY (`PV_C_CODIGO`);

--
-- Indices de la tabla `sm_provincia`
--
ALTER TABLE `sm_provincia`
  ADD PRIMARY KEY (`P_C_CODIGO`),
  ADD KEY `FK_DEP_C_CODIGO` (`DEP_C_CODIGO`);

--
-- Indices de la tabla `sm_sexo`
--
ALTER TABLE `sm_sexo`
  ADD PRIMARY KEY (`SEX_C_CODIGO`);

--
-- Indices de la tabla `sm_tbcategorias`
--
ALTER TABLE `sm_tbcategorias`
  ADD PRIMARY KEY (`TEG_C_CODIGO`);

--
-- Indices de la tabla `sm_tbingegre`
--
ALTER TABLE `sm_tbingegre`
  ADD PRIMARY KEY (`EIG_C_CODIGO`),
  ADD KEY `FK_US_C_CODIGO09` (`US_C_CODIGO`),
  ADD KEY `FK_CAT_C_CODIGO_99` (`TEG_C_CODIGO`);

--
-- Indices de la tabla `sm_tipodoc`
--
ALTER TABLE `sm_tipodoc`
  ADD PRIMARY KEY (`TD_C_CODIGO`);

--
-- Indices de la tabla `sm_ubigeo`
--
ALTER TABLE `sm_ubigeo`
  ADD PRIMARY KEY (`UBI_C_CODIGO`),
  ADD KEY `FK_DEP_C_CODIGO` (`DEP_C_CODIGO`),
  ADD KEY `FK_P_C_CODIGO` (`P_C_CODIGO`),
  ADD KEY `FK_DIS_C_CODIGO` (`DIS_C_CODIGO`);

--
-- Indices de la tabla `sm_usuario`
--
ALTER TABLE `sm_usuario`
  ADD PRIMARY KEY (`US_C_CODIGO`),
  ADD KEY `FK_PER_C_CODIGO` (`PER_C_CODIGO`),
  ADD KEY `FK_PRI_C_CODIGO` (`PRI_C_CODIGO`);

--
-- Indices de la tabla `sm_utilidad`
--
ALTER TABLE `sm_utilidad`
  ADD PRIMARY KEY (`UTI_C_CODIGO`);

--
-- Indices de la tabla `sm_ventas`
--
ALTER TABLE `sm_ventas`
  ADD PRIMARY KEY (`VEN_C_CODIGO`),
  ADD KEY `FK_CLI_C_CODIGO0001` (`CLI_C_CODIGO`),
  ADD KEY `FK_US_C_CODIGO` (`US_C_CODIGO`);

--
-- Indices de la tabla `sm_vista`
--
ALTER TABLE `sm_vista`
  ADD PRIMARY KEY (`VIS_C_CODIGO`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `dg_permisos`
--
ALTER TABLE `dg_permisos`
  MODIFY `PRM_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;
--
-- AUTO_INCREMENT de la tabla `dg_roles`
--
ALTER TABLE `dg_roles`
  MODIFY `RO_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `dg_sedes`
--
ALTER TABLE `dg_sedes`
  MODIFY `SED_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `dg_user`
--
ALTER TABLE `dg_user`
  MODIFY `US_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT de la tabla `dg_vistas`
--
ALTER TABLE `dg_vistas`
  MODIFY `VIS_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT de la tabla `sm_capitaldia`
--
ALTER TABLE `sm_capitaldia`
  MODIFY `CAP_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=141;
--
-- AUTO_INCREMENT de la tabla `sm_categoria`
--
ALTER TABLE `sm_categoria`
  MODIFY `CAT_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT de la tabla `sm_cliente`
--
ALTER TABLE `sm_cliente`
  MODIFY `CLI_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;
--
-- AUTO_INCREMENT de la tabla `sm_compra`
--
ALTER TABLE `sm_compra`
  MODIFY `C_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1533;
--
-- AUTO_INCREMENT de la tabla `sm_cuentasCompras`
--
ALTER TABLE `sm_cuentasCompras`
  MODIFY `CC_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=256;
--
-- AUTO_INCREMENT de la tabla `sm_cuentasVentas`
--
ALTER TABLE `sm_cuentasVentas`
  MODIFY `CV_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=227;
--
-- AUTO_INCREMENT de la tabla `sm_depositos`
--
ALTER TABLE `sm_depositos`
  MODIFY `DEP_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT de la tabla `sm_detordenes`
--
ALTER TABLE `sm_detordenes`
  MODIFY `DTL_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=253;
--
-- AUTO_INCREMENT de la tabla `sm_detvista`
--
ALTER TABLE `sm_detvista`
  MODIFY `DTV_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `sm_dtcompras`
--
ALTER TABLE `sm_dtcompras`
  MODIFY `COM_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2050;
--
-- AUTO_INCREMENT de la tabla `sm_dtventas`
--
ALTER TABLE `sm_dtventas`
  MODIFY `DVE_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4498;
--
-- AUTO_INCREMENT de la tabla `sm_entregas_pro`
--
ALTER TABLE `sm_entregas_pro`
  MODIFY `ENTP_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `sm_estadocivil`
--
ALTER TABLE `sm_estadocivil`
  MODIFY `EC_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `sm_hisVentas`
--
ALTER TABLE `sm_hisVentas`
  MODIFY `HVE_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `sm_imgs`
--
ALTER TABLE `sm_imgs`
  MODIFY `IMG_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT de la tabla `sm_ingcat`
--
ALTER TABLE `sm_ingcat`
  MODIFY `ICT_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT de la tabla `sm_marca`
--
ALTER TABLE `sm_marca`
  MODIFY `MAR_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;
--
-- AUTO_INCREMENT de la tabla `sm_ordenes`
--
ALTER TABLE `sm_ordenes`
  MODIFY `ORD_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=137;
--
-- AUTO_INCREMENT de la tabla `sm_pagosC`
--
ALTER TABLE `sm_pagosC`
  MODIFY `PC_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1133;
--
-- AUTO_INCREMENT de la tabla `sm_pagoscompras`
--
ALTER TABLE `sm_pagoscompras`
  MODIFY `PGC_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT de la tabla `sm_pagosV`
--
ALTER TABLE `sm_pagosV`
  MODIFY `VV_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=746;
--
-- AUTO_INCREMENT de la tabla `sm_pagoventas`
--
ALTER TABLE `sm_pagoventas`
  MODIFY `PGV_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT de la tabla `sm_patrimonio`
--
ALTER TABLE `sm_patrimonio`
  MODIFY `PTR_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT de la tabla `sm_persona`
--
ALTER TABLE `sm_persona`
  MODIFY `PER_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=115;
--
-- AUTO_INCREMENT de la tabla `sm_privilegios`
--
ALTER TABLE `sm_privilegios`
  MODIFY `PRI_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `sm_productos`
--
ALTER TABLE `sm_productos`
  MODIFY `PRO_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=355;
--
-- AUTO_INCREMENT de la tabla `sm_provedores`
--
ALTER TABLE `sm_provedores`
  MODIFY `PV_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=70;
--
-- AUTO_INCREMENT de la tabla `sm_sexo`
--
ALTER TABLE `sm_sexo`
  MODIFY `SEX_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `sm_tbcategorias`
--
ALTER TABLE `sm_tbcategorias`
  MODIFY `TEG_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT de la tabla `sm_tbingegre`
--
ALTER TABLE `sm_tbingegre`
  MODIFY `EIG_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;
--
-- AUTO_INCREMENT de la tabla `sm_tipodoc`
--
ALTER TABLE `sm_tipodoc`
  MODIFY `TD_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `sm_ubigeo`
--
ALTER TABLE `sm_ubigeo`
  MODIFY `UBI_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `sm_usuario`
--
ALTER TABLE `sm_usuario`
  MODIFY `US_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT de la tabla `sm_utilidad`
--
ALTER TABLE `sm_utilidad`
  MODIFY `UTI_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=129;
--
-- AUTO_INCREMENT de la tabla `sm_ventas`
--
ALTER TABLE `sm_ventas`
  MODIFY `VEN_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1921;
--
-- AUTO_INCREMENT de la tabla `sm_vista`
--
ALTER TABLE `sm_vista`
  MODIFY `VIS_C_CODIGO` int(11) NOT NULL AUTO_INCREMENT;
--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `dg_user`
--
ALTER TABLE `dg_user`
  ADD CONSTRAINT `fk_dg_sedes_sed_c_odigo` FOREIGN KEY (`SED_C_CODIGO`) REFERENCES `dg_sedes` (`SED_C_CODIGO`);

--
-- Filtros para la tabla `sm_detordenes`
--
ALTER TABLE `sm_detordenes`
  ADD CONSTRAINT `sm_detordenes_ibfk_1` FOREIGN KEY (`PRO_C_CODIGO`) REFERENCES `sm_productos` (`PRO_C_CODIGO`),
  ADD CONSTRAINT `sm_detordenes_ibfk_2` FOREIGN KEY (`ORD_C_CODIGO`) REFERENCES `sm_ordenes` (`ORD_C_CODIGO`);

--
-- Filtros para la tabla `sm_detvista`
--
ALTER TABLE `sm_detvista`
  ADD CONSTRAINT `sm_detvista_ibfk_1` FOREIGN KEY (`VIS_C_CODIGO`) REFERENCES `sm_vista` (`VIS_C_CODIGO`),
  ADD CONSTRAINT `sm_detvista_ibfk_2` FOREIGN KEY (`US_C_CODIGO`) REFERENCES `sm_usuario` (`US_C_CODIGO`);

--
-- Filtros para la tabla `sm_distrito`
--
ALTER TABLE `sm_distrito`
  ADD CONSTRAINT `sm_distrito_ibfk_1` FOREIGN KEY (`P_C_CODIGO`) REFERENCES `sm_provincia` (`P_C_CODIGO`);

--
-- Filtros para la tabla `sm_entregas_pro`
--
ALTER TABLE `sm_entregas_pro`
  ADD CONSTRAINT `sm_entregas_pro_ibfk_1` FOREIGN KEY (`PRO_C_CODIGO`) REFERENCES `sm_productos` (`PRO_C_CODIGO`),
  ADD CONSTRAINT `sm_entregas_pro_ibfk_2` FOREIGN KEY (`CLI_C_CODIGO`) REFERENCES `sm_cliente` (`CLI_C_CODIGO`),
  ADD CONSTRAINT `sm_entregas_pro_ibfk_3` FOREIGN KEY (`DTL_C_CODIGO`) REFERENCES `sm_detordenes` (`DTL_C_CODIGO`);

--
-- Filtros para la tabla `sm_ordenes`
--
ALTER TABLE `sm_ordenes`
  ADD CONSTRAINT `sm_ordenes_ibfk_1` FOREIGN KEY (`CLI_C_CODIGO`) REFERENCES `sm_cliente` (`CLI_C_CODIGO`);

--
-- Filtros para la tabla `sm_productos`
--
ALTER TABLE `sm_productos`
  ADD CONSTRAINT `sm_productos_ibfk_1` FOREIGN KEY (`MAR_C_CODIGO`) REFERENCES `sm_marca` (`MAR_C_CODIGO`),
  ADD CONSTRAINT `sm_productos_ibfk_2` FOREIGN KEY (`CAT_C_CODIGO`) REFERENCES `sm_categoria` (`CAT_C_CODIGO`),
  ADD CONSTRAINT `sm_productos_ibfk_3` FOREIGN KEY (`PV_C_CODIGO`) REFERENCES `sm_provedores` (`PV_C_CODIGO`);

--
-- Filtros para la tabla `sm_provincia`
--
ALTER TABLE `sm_provincia`
  ADD CONSTRAINT `sm_provincia_ibfk_1` FOREIGN KEY (`DEP_C_CODIGO`) REFERENCES `sm_departamento` (`DEP_C_CODIGO`);

--
-- Filtros para la tabla `sm_ubigeo`
--
ALTER TABLE `sm_ubigeo`
  ADD CONSTRAINT `sm_ubigeo_ibfk_1` FOREIGN KEY (`DEP_C_CODIGO`) REFERENCES `sm_departamento` (`DEP_C_CODIGO`),
  ADD CONSTRAINT `sm_ubigeo_ibfk_2` FOREIGN KEY (`P_C_CODIGO`) REFERENCES `sm_provincia` (`P_C_CODIGO`),
  ADD CONSTRAINT `sm_ubigeo_ibfk_3` FOREIGN KEY (`DIS_C_CODIGO`) REFERENCES `sm_distrito` (`DIS_C_CODIGO`);

--
-- Filtros para la tabla `sm_usuario`
--
ALTER TABLE `sm_usuario`
  ADD CONSTRAINT `sm_usuario_ibfk_1` FOREIGN KEY (`PER_C_CODIGO`) REFERENCES `sm_persona` (`PER_C_CODIGO`),
  ADD CONSTRAINT `sm_usuario_ibfk_2` FOREIGN KEY (`PRI_C_CODIGO`) REFERENCES `sm_privilegios` (`PRI_C_CODIGO`);
