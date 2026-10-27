import pathlib
import subprocess
import tempfile
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
VALIDATOR = ROOT / "scripts" / "validate-skills.sh"


class ValidateSkillsTests(unittest.TestCase):
    def validate(self, file_content, skill_dir="example-skill"):
        with tempfile.TemporaryDirectory() as temporary_directory:
            skills_dir = pathlib.Path(temporary_directory) / "skills"
            skill_path = skills_dir / skill_dir / "SKILL.md"
            skill_path.parent.mkdir(parents=True)
            skill_path.write_text(file_content, encoding="utf-8")
            return subprocess.run(
                ["bash", str(VALIDATOR), str(skills_dir)],
                text=True,
                capture_output=True,
                check=False,
            )

    def test_valid_metadata_passes(self):
        result = self.validate(
            "---\nname: example-skill\ndescription: A useful skill.\n---\n\n# Example\n"
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_description_length_boundary(self):
        valid = self.validate(
            f"---\nname: example-skill\ndescription: {'d' * 1024}\n---\n# Example\n"
        )
        self.assertEqual(valid.returncode, 0, valid.stderr)

        invalid = self.validate(
            f"---\nname: example-skill\ndescription: {'d' * 1025}\n---\n# Example\n"
        )
        self.assertNotEqual(invalid.returncode, 0)
        self.assertIn("description must be at most 1024", invalid.stderr)

    def test_one_character_name_is_valid(self):
        result = self.validate("---\nname: x\ndescription: A useful skill.\n---\n# Example\n", "x")
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_64_character_name_is_valid(self):
        name = "a" * 64
        result = self.validate(
            f"---\nname: {name}\ndescription: A useful skill.\n---\n# Example\n", name
        )
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_missing_frontmatter_fails(self):
        result = self.validate("# Example\nname: example-skill\ndescription: elsewhere\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("frontmatter must start", result.stderr)

    def test_missing_closing_frontmatter_fails(self):
        result = self.validate("---\nname: example-skill\ndescription: A skill.\n")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("missing its closing", result.stderr)

    def test_missing_required_fields_fail(self):
        for metadata in ("name: example-skill", "description: A skill."):
            with self.subTest(metadata=metadata):
                result = self.validate(f"---\n{metadata}\n---\n# Example\n")
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("missing required", result.stderr)

    def test_empty_required_values_fail(self):
        for metadata in (
            'name: ""\ndescription: A skill.',
            'name: example-skill\ndescription: ""',
            'name: null\ndescription: A skill.',
        ):
            with self.subTest(metadata=metadata):
                result = self.validate(f"---\n{metadata}\n---\n# Example\n")
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("non-empty string", result.stderr)

    def test_invalid_names_fail(self):
        invalid_names = [
            "-example-skill",
            "example-skill-",
            "example--skill",
            "Example-skill",
            "example_skill",
            "x" * 65,
        ]
        for name in invalid_names:
            with self.subTest(name=name):
                result = self.validate(
                    f"---\nname: {name}\ndescription: A skill.\n---\n# Example\n",
                    skill_dir=name if name not in ("-example-skill", "example-skill-") else "other-skill",
                )
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("name must be 1-64", result.stderr)

    def test_directory_mismatch_fails(self):
        result = self.validate(
            "---\nname: different-skill\ndescription: A skill.\n---\n# Example\n"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("must match parent directory", result.stderr)

    def test_malformed_yaml_fails(self):
        result = self.validate(
            "---\nname: [unterminated\ndescription: A skill.\n---\n# Example\n"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("malformed YAML", result.stderr)

    def test_duplicate_yaml_keys_fail_explicitly(self):
        result = self.validate(
            "---\nname: example-skill\nname: another-skill\n"
            "description: A useful skill.\n---\n# Example\n"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("duplicate YAML key 'name'", result.stderr)

    def test_missing_closing_delimiter_fails_even_with_other_delimiters_later(self):
        result = self.validate(
            "---\nname: example-skill\ndescription: A useful skill.\n"
            "# Example\n--- not a closing delimiter\n"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("missing its closing", result.stderr)

    def test_metadata_outside_frontmatter_does_not_count(self):
        result = self.validate(
            "---\nother: value\n---\nname: example-skill\ndescription: A skill.\n# Example\n"
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("missing required name", result.stderr)


if __name__ == "__main__":
    unittest.main()
