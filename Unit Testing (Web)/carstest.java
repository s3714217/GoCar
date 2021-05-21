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
public class carstest {
	
		
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
		@Order(3)
		public void carpage() {
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"sidebarMenu\"]/ul/li[3]/a"));
			chromeWebElement.click();
			
			expectedResult = "Car Management | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
		}
		
	
		@Test
		@Order(4)
		public void list() {
			
			
			expectedResult = "Car Management | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
			
			
			//No.of rows 
			List<WebElement>  rows = driver.findElements(By.xpath("//*[@id=\"carTable\"]/tr/td[1]")); 
			System.out.println("No of rows are : " + rows.size());
        
			int expectedsize = 115;
			int tablesize = rows.size();
			assertEquals(expectedsize, tablesize);
		
	}
		
		
		
		@Test
		@Order(5)
		public void addcarpage() {
			driver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS); 
			WebElement chromeWebElement = driver.findElement(By.xpath("/html/body/div/div/div[2]/div[1]/div[1]/div[2]/button/img"));
			chromeWebElement.click();
			
			expectedResult = "Add New Car | GoCar";
			actualResult = driver.getTitle();
			assertEquals(expectedResult, actualResult);
		}
		
		
		
		@Test
		@Order(6)
		public void add() {
			
			WebElement chromeWebElement = driver.findElement(By.xpath("//*[@id=\"carModel\"]"));
			Wait wait = new WebDriverWait(driver, 10);
		    wait.until(ExpectedConditions.visibilityOf(chromeWebElement));
		    
			chromeWebElement.sendKeys("Honda CR-V");
			Select dropdown = new Select(driver.findElement(By.xpath("//*[@id=\"carCondition\"]")));
			dropdown.selectByVisibleText("New");
			dropdown = new Select(driver.findElement(By.xpath("//*[@id=\"parkingLocation\"]")));
			dropdown.selectByVisibleText("8-14 Malvina Pl, Carlton VIC 3053");
			dropdown = new Select(driver.findElement(By.xpath("//*[@id=\"carType\"]")));
			dropdown.selectByVisibleText("SUV");
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"carRate\"]"));
			chromeWebElement.sendKeys("200");
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"carID\"]"));
			chromeWebElement.sendKeys("4888888");
			chromeWebElement = driver.findElement(By.xpath("//*[@id=\"addCarButton\"]"));
			chromeWebElement.click();
			
			expectedResult = "Car was added successfully";
			chromeWebElement = driver.findElement(By.id("carAddedSuccess"));
			wait.until(ExpectedConditions.visibilityOf(chromeWebElement));
			actualResult = chromeWebElement.getText();
			assertEquals(expectedResult, actualResult);
		
		
		}
		
	
		   
		
		
		

	@AfterAll
		
		public static void close() {
		driver.close();
		}
	
		
}