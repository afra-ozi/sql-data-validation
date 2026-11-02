import unittest

from run_checks import demo_connection, load_checks, run


class TestChecks(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.results = {name: rows for name, _, rows in run(demo_connection(), load_checks())}

    def test_all_checks_loaded(self):
        self.assertEqual(len(self.results), 7)

    def test_expected_failures_in_demo_data(self):
        ids = lambda name: {r[0] for r in self.results[name]}
        self.assertEqual(ids("tasks with a missing label"), {104})
        self.assertEqual(ids("labels outside the allowed set for their project"), {103})  # NULL labels are caught by the missing-label check
        self.assertEqual(ids("tasks pointing at an annotator that does not exist (orphan rows)"), {106})
        self.assertEqual(ids("completed before it was created"), {105})
        self.assertEqual(ids("suspiciously fast tasks (under 5 seconds) that may need a quality review"), {107})


if __name__ == "__main__":
    unittest.main()
