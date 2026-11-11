-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`dim_date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_date` (
  `iddim_date` INT NOT NULL AUTO_INCREMENT,
  `day` INT NOT NULL,
  `month` INT NOT NULL,
  `year` INT NOT NULL,
  `week` INT NOT NULL,
  PRIMARY KEY (`iddim_date`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_time`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_time` (
  `iddim_time` INT NOT NULL AUTO_INCREMENT,
  `hour` INT NOT NULL,
  `minute` INT NOT NULL,
  `second` INT NOT NULL,
  `dim_timecol` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddim_time`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sdim_language`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`sdim_language` (
  `idsdim_language` INT NOT NULL AUTO_INCREMENT,
  `language_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idsdim_language`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_product` (
  `iddim_product` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `release_year` INT NOT NULL,
  `rating` DOUBLE NOT NULL,
  `sdim_language_idsdim_language` INT NOT NULL,
  PRIMARY KEY (`iddim_product`, `sdim_language_idsdim_language`),
  INDEX `fk_dim_product_sdim_language1_idx` (`sdim_language_idsdim_language` ASC) VISIBLE,
  CONSTRAINT `fk_dim_product_sdim_language1`
    FOREIGN KEY (`sdim_language_idsdim_language`)
    REFERENCES `mydb`.`sdim_language` (`idsdim_language`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sdim_country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`sdim_country` (
  `idsdim_country` INT NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idsdim_country`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sdim_city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`sdim_city` (
  `idsdim_city` INT NOT NULL AUTO_INCREMENT,
  `city_name` VARCHAR(45) NOT NULL,
  `sdim_country_idsdim_country` INT NOT NULL,
  PRIMARY KEY (`idsdim_city`),
  INDEX `fk_sdim_city_sdim_country1_idx` (`sdim_country_idsdim_country` ASC) VISIBLE,
  CONSTRAINT `fk_sdim_city_sdim_country1`
    FOREIGN KEY (`sdim_country_idsdim_country`)
    REFERENCES `mydb`.`sdim_country` (`idsdim_country`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sdim_address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`sdim_address` (
  `idsdim_address` INT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(45) NOT NULL,
  `district` VARCHAR(45) NOT NULL,
  `postal_code` VARCHAR(10) NOT NULL,
  `sdim_city_idsdim_city` INT NOT NULL,
  PRIMARY KEY (`idsdim_address`),
  INDEX `fk_sdim_address_sdim_city1_idx` (`sdim_city_idsdim_city` ASC) VISIBLE,
  CONSTRAINT `fk_sdim_address_sdim_city1`
    FOREIGN KEY (`sdim_city_idsdim_city`)
    REFERENCES `mydb`.`sdim_city` (`idsdim_city`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_customer` (
  `iddim_customer` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `sdim_address_idsdim_address` INT NOT NULL,
  PRIMARY KEY (`iddim_customer`),
  INDEX `fk_dim_customer_sdim_address1_idx` (`sdim_address_idsdim_address` ASC) VISIBLE,
  CONSTRAINT `fk_dim_customer_sdim_address1`
    FOREIGN KEY (`sdim_address_idsdim_address`)
    REFERENCES `mydb`.`sdim_address` (`idsdim_address`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_store` (
  `iddim_store` INT NOT NULL AUTO_INCREMENT,
  `store_name` VARCHAR(45) NOT NULL,
  `sdim_address_idsdim_address` INT NOT NULL,
  PRIMARY KEY (`iddim_store`),
  INDEX `fk_dim_store_sdim_address1_idx` (`sdim_address_idsdim_address` ASC) VISIBLE,
  CONSTRAINT `fk_dim_store_sdim_address1`
    FOREIGN KEY (`sdim_address_idsdim_address`)
    REFERENCES `mydb`.`sdim_address` (`idsdim_address`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_staff` (
  `iddim_staff` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `dim_store_iddim_store` INT NOT NULL,
  PRIMARY KEY (`iddim_staff`),
  INDEX `fk_dim_staff_dim_store1_idx` (`dim_store_iddim_store` ASC) VISIBLE,
  CONSTRAINT `fk_dim_staff_dim_store1`
    FOREIGN KEY (`dim_store_iddim_store`)
    REFERENCES `mydb`.`dim_store` (`iddim_store`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`fact_sales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`fact_sales` (
  `iddim_sales` INT NOT NULL AUTO_INCREMENT,
  `product_quantity` INT NOT NULL,
  `product_price` DECIMAL(10,2) NOT NULL,
  `sales_amount` DECIMAL(10,2) NOT NULL,
  `dim_date_iddim_date` INT NOT NULL,
  `dim_time_iddim_time` INT NOT NULL,
  `dim_product_iddim_product` INT NOT NULL,
  `dim_product_sdim_language_idsdim_language` INT NOT NULL,
  `dim_customer_iddim_customer` INT NOT NULL,
  `dim_store_iddim_store` INT NOT NULL,
  `dim_staff_iddim_staff` INT NOT NULL,
  PRIMARY KEY (`iddim_sales`, `dim_product_iddim_product`, `dim_product_sdim_language_idsdim_language`, `dim_customer_iddim_customer`, `dim_staff_iddim_staff`),
  INDEX `fk_fact_sales_dim_date1_idx` (`dim_date_iddim_date` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_time1_idx` (`dim_time_iddim_time` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_product1_idx` (`dim_product_iddim_product` ASC, `dim_product_sdim_language_idsdim_language` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_customer1_idx` (`dim_customer_iddim_customer` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_store1_idx` (`dim_store_iddim_store` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_staff1_idx` (`dim_staff_iddim_staff` ASC) VISIBLE,
  CONSTRAINT `fk_fact_sales_dim_date1`
    FOREIGN KEY (`dim_date_iddim_date`)
    REFERENCES `mydb`.`dim_date` (`iddim_date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_time1`
    FOREIGN KEY (`dim_time_iddim_time`)
    REFERENCES `mydb`.`dim_time` (`iddim_time`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_product1`
    FOREIGN KEY (`dim_product_iddim_product` , `dim_product_sdim_language_idsdim_language`)
    REFERENCES `mydb`.`dim_product` (`iddim_product` , `sdim_language_idsdim_language`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_customer1`
    FOREIGN KEY (`dim_customer_iddim_customer`)
    REFERENCES `mydb`.`dim_customer` (`iddim_customer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_store1`
    FOREIGN KEY (`dim_store_iddim_store`)
    REFERENCES `mydb`.`dim_store` (`iddim_store`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_staff1`
    FOREIGN KEY (`dim_staff_iddim_staff`)
    REFERENCES `mydb`.`dim_staff` (`iddim_staff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sdim_category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`sdim_category` (
  `idsdim_category` INT NOT NULL AUTO_INCREMENT,
  `category_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idsdim_category`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`sdim_actor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`sdim_actor` (
  `idsdim_actor` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idsdim_actor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`bridge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`bridge` (
  `idbridge` INT NOT NULL AUTO_INCREMENT,
  `dim_product_iddim_product` INT NOT NULL,
  `sdim_actor_idsdim_actor` INT NOT NULL,
  PRIMARY KEY (`idbridge`),
  INDEX `fk_bridge_dim_product1_idx` (`dim_product_iddim_product` ASC) VISIBLE,
  INDEX `fk_bridge_sdim_actor1_idx` (`sdim_actor_idsdim_actor` ASC) VISIBLE,
  CONSTRAINT `fk_bridge_dim_product1`
    FOREIGN KEY (`dim_product_iddim_product`)
    REFERENCES `mydb`.`dim_product` (`iddim_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bridge_sdim_actor1`
    FOREIGN KEY (`sdim_actor_idsdim_actor`)
    REFERENCES `mydb`.`sdim_actor` (`idsdim_actor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`bridge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`bridge` (
  `idbridge` INT NOT NULL AUTO_INCREMENT,
  `dim_product_iddim_product` INT NOT NULL,
  `sdim_actor_idsdim_actor` INT NOT NULL,
  PRIMARY KEY (`idbridge`),
  INDEX `fk_bridge_dim_product1_idx` (`dim_product_iddim_product` ASC) VISIBLE,
  INDEX `fk_bridge_sdim_actor1_idx` (`sdim_actor_idsdim_actor` ASC) VISIBLE,
  CONSTRAINT `fk_bridge_dim_product1`
    FOREIGN KEY (`dim_product_iddim_product`)
    REFERENCES `mydb`.`dim_product` (`iddim_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bridge_sdim_actor1`
    FOREIGN KEY (`sdim_actor_idsdim_actor`)
    REFERENCES `mydb`.`sdim_actor` (`idsdim_actor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
