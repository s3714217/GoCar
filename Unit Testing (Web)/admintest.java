package gocar;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;
import java.util.concurrent.TimeUnit;

import org.junit.Before;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import org.junit.jupiter.api.TestInstance.Lifecycle;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.Wait;
import org.openqa.selenium.support.ui.WebDriverWait;




@TestMethodOrder(OrderAnnotation.class) 
public class admintest {
	
		
		private static ChromeDriver driver;
		private String expectedResult;
		private String actualResult;
	

		@BeforeAll

		public static void setup() {
			System.setProperty("Webdriver.chrome.driver", "chromedriver.exe");
			
			driver = new ChromeDriver();

		}
		
		
		@Test
		@Order(1)
		public void website() {

			driver.get("https://gocarrmit.ts.r.appspot.com/");
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
		
			expectedResult = "Login | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
		

		}
		
		
		@Test
		@Order(2)
		public void Login() {
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"username\"]"));
			chromeWebElement.clear();
			chromeWebElement.sendKeys("admin_master@gocar.com");
			expectedResult = "Welcome admin_master@gocar.com";
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"password\"]"));
			chromeWebElement.sendKeys("MASTERpassword1@");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"login\"]"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"user\"]"));
			actualResult = chromeWebElement.getText();
			assertEquals(expectedResult, actualResult);
			
			
		}
		
		
		
		
		@Test
		@Order(4) 
		public void Adminpage() {
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[6]/a"));
			chromeWebElement.click();
			
		
		}
		
		@Test
		@Order(5)
		public void list() {
			
		
			
			
			//No.of rows 
			List<WebElement>  rows = driver.findElements(By.xpath("//*[@id=\"adminTable\"]/tr/td[1]")); 
			System.out.println("No of rows are : " + rows.size());
        
			int expectedsize = 5;
			int tablesize = rows.size();
			assertEquals(expectedsize, tablesize);
		
	}
		
		@Test
		@Order(6)
		public void Addadmin() {
			
			WebElement chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[1]/div[2]/button/img"));
			chromeWebElement.click();
			
			
			
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);
			
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"adminUsername\"]"));
			Wait wait = new WebDriverWait(driver, 10);
		    wait.until(ExpectedConditions.visibilityOf(chromeWebElement));
			chromeWebElement.sendKeys("admin_test@gocar.com");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"adminPassword\"]"));
			chromeWebElement.sendKeys("MASTERpassword1@");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"addAdminButton\"]"));
			chromeWebElement.click();
			
		}
		
		@Test
		@Order(7) 
		public void changepass() {
			WebElement chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[2]/div/div[2]/table/tbody/tr[5]/td[2]/button[1]"));
			driver.manage().timeouts().implicitlyWait(15, TimeUnit.SECONDS);
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"newPassword\"]"));
			chromeWebElement.sendKeys("MASTERpassword2@");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"confirmPassword\"]"));
			chromeWebElement.sendKeys("MASTERpassword2@");
			
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"addAdminButton\"]"));
			chromeWebElement.click();
			
			
		}
		
		@Test
		@Order(8) 
		public void deletetest() {
			
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[6]/a"));
			chromeWebElement.click();
			
			chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[2]/div/div[2]/table/tbody/tr[6]/td[2]/button[2]"));
			chromeWebElement.click();
			
			
		}
		
	@AfterAll
		
		public static void close() {
		
		}
	
		
}

		