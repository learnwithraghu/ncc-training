import unittest

from app import greet


class TestApp(unittest.TestCase):
    def test_default_name(self):
        self.assertEqual(greet(), "Hello, Jenkins!")

    def test_custom_name(self):
        self.assertEqual(greet("Team"), "Hello, Team!")


if __name__ == "__main__":
    unittest.main()
