import unittest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.webdriver.common.appiumby import AppiumBy

class AuthTest(unittest.TestCase):
    def setUp(self):
        options = UiAutomator2Options()
        options.platform_name = 'Android'
        options.automation_name = 'UiAutomator2'
        options.device_name = 'emulator-5554'
        # Ensure this path is correct for your machine
        options.app = r'C:\Users\abdel\laza_ecommerce\build\app\outputs\flutter-apk\app-debug.apk'

        self.driver = webdriver.Remote('http://localhost:4723', options=options)

    def test_auth_flow(self):
        # 1. Signup (Assuming labels are set in Flutter Semantics)
        self.driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='signup_button').click()
        self.driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='email_field').send_keys("test@test.com")
        self.driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='password_field').send_keys("Pass1234")
        self.driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='submit_signup').click()

        # 2. Login
        self.driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='login_button').click()

        # 3. Validate Home
        home_el = self.driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='home_screen')
        self.assertTrue(home_el.is_displayed())
        self.driver.get_screenshot_as_file("../../docs/results/auth_test_screenshot.png")

    def tearDown(self):
        self.driver.quit()

if __name__ == '__main__':
    unittest.main()