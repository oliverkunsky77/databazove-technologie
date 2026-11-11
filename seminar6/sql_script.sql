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
  `invoice_date` DATETIME NOT NULL,
  `day` INT NOT NULL,
  `month` INT NOT NULL,
  `year` INT NOT NULL,
  `weekday` VARCHAR(45) NOT NULL,
  `quarter` INT NOT NULL,
  `day_name` VARCHAR(10) NOT NULL,
  `month_name` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`iddim_date`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_employee` (
  `iddim_employee` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `address` VARCHAR(45) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NULL,
  `country` VARCHAR(45) NOT NULL,
  `postal_code` VARCHAR(10) NOT NULL,
  `title` VARCHAR(45) NOT NULL,
  `hire_date` DATE NOT NULL,
  `birth_date` DATE NOT NULL,
  PRIMARY KEY (`iddim_employee`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_billing_address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_billing_address` (
  `iddim_billing_address` INT NOT NULL AUTO_INCREMENT,
  `billing_city` VARCHAR(255) NOT NULL,
  `billing_state` VARCHAR(255) NULL,
  `biling_country` VARCHAR(255) NOT NULL,
  `billing_postal_code` VARCHAR(10) NOT NULL,
  `dim_billing_address` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`iddim_billing_address`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_customer` (
  `iddim_customer` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `city` VARCHAR(255) NOT NULL,
  `state` VARCHAR(45) NULL,
  `country` VARCHAR(45) NOT NULL,
  `postal_code` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddim_customer`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_track`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_track` (
  `iddim_track` INT NOT NULL AUTO_INCREMENT,
  `album_title` VARCHAR(45) NOT NULL,
  `track_name` VARCHAR(45) NOT NULL,
  `composer` VARCHAR(45) NOT NULL,
  `genre` VARCHAR(45) NOT NULL,
  `bytes` INT NULL,
  `milliseconds` INT NULL,
  `media_type` VARCHAR(45) NOT NULL,
  `artist_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddim_track`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`fact_sales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`fact_sales` (
  `idfact_sales` INT NOT NULL AUTO_INCREMENT,
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `sales_amount` DECIMAL(10,2) NOT NULL,
  `order_count` INT NOT NULL,
  `dim_date_iddim_date` INT NOT NULL,
  `dim_employee_iddim_employee` INT NOT NULL,
  `dim_billing_address_iddim_billing_address` INT NOT NULL,
  `dim_customer_iddim_customer` INT NOT NULL,
  `dim_track_iddim_track` INT NOT NULL,
  PRIMARY KEY (`idfact_sales`),
  INDEX `fk_fact_sales_dim_date_idx` (`dim_date_iddim_date` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_employee1_idx` (`dim_employee_iddim_employee` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_billing_address1_idx` (`dim_billing_address_iddim_billing_address` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_customer1_idx` (`dim_customer_iddim_customer` ASC) VISIBLE,
  INDEX `fk_fact_sales_dim_track1_idx` (`dim_track_iddim_track` ASC) VISIBLE,
  CONSTRAINT `fk_fact_sales_dim_date`
    FOREIGN KEY (`dim_date_iddim_date`)
    REFERENCES `mydb`.`dim_date` (`iddim_date`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_employee1`
    FOREIGN KEY (`dim_employee_iddim_employee`)
    REFERENCES `mydb`.`dim_employee` (`iddim_employee`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_billing_address1`
    FOREIGN KEY (`dim_billing_address_iddim_billing_address`)
    REFERENCES `mydb`.`dim_billing_address` (`iddim_billing_address`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_customer1`
    FOREIGN KEY (`dim_customer_iddim_customer`)
    REFERENCES `mydb`.`dim_customer` (`iddim_customer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_sales_dim_track1`
    FOREIGN KEY (`dim_track_iddim_track`)
    REFERENCES `mydb`.`dim_track` (`iddim_track`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_playlist` (
  `iddim_playlist` INT NOT NULL AUTO_INCREMENT,
  `playlist_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`iddim_playlist`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`bridge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`bridge` (
  `idbridge` INT NOT NULL AUTO_INCREMENT,
  `dim_playlist_iddim_playlist` INT NOT NULL,
  `dim_track_iddim_track` INT NOT NULL,
  PRIMARY KEY (`idbridge`),
  INDEX `fk_bridge_dim_playlist1_idx` (`dim_playlist_iddim_playlist` ASC) VISIBLE,
  INDEX `fk_bridge_dim_track1_idx` (`dim_track_iddim_track` ASC) VISIBLE,
  CONSTRAINT `fk_bridge_dim_playlist1`
    FOREIGN KEY (`dim_playlist_iddim_playlist`)
    REFERENCES `mydb`.`dim_playlist` (`iddim_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_bridge_dim_track1`
    FOREIGN KEY (`dim_track_iddim_track`)
    REFERENCES `mydb`.`dim_track` (`iddim_track`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
