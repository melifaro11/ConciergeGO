import subprocess
from langchain_ollama.llms import OllamaLLM
from langchain_core.prompts import PromptTemplate


def get_diff() -> str | None:
    """
    Get output of `git diff` as a string or None if error
    """
    result = subprocess.run(["git", "--no-pager", "diff"], capture_output=True, text=True)

    if result.returncode != 0:
        print(f"`git diff` error:\n{result.stderr}")
        return None

    return result.stdout

def gen_comment(diff_text: str) -> str:
    """
    Generate text comment for changes with a LLM-agent
    """
    if not diff_text.strip():
        return "No changes"

    chain = PromptTemplate.from_template(
                    "Write a short, generalized informative commit message for the following changes."
                    "Use English only, and the passive present (e.g., 'done', 'added', 'fixed')."
                    "Don't use quotes, reply ONLY with commit message."
                    "Limit yourself to 80-100 characters. Changes:\n\n{diff}"
                ) | OllamaLLM(model="llama3.2")

    response = chain.invoke({"diff": diff_text})

    return response.strip()

def git_commit(commit_message):
    """
    Run git commit/push
    """
    subprocess.run(["git", "add", "."], check=True)

    commit_result = subprocess.run(
        ["git", "commit", "-m", commit_message],
        capture_output=True,
        text=True
    )
    if commit_result.returncode != 0:
        print("`git commit` error:\n{commit_result.stderr}")
        return False

    print(commit_result.stdout)

    return True

def git_push():
    push_result = subprocess.run(
        ["git", "push"],
        capture_output=True,
        text=True
    )
    if push_result.returncode != 0:
        print("`git push` error:\n{push_result.stderr}")
        return False

    print(push_result.stdout)
    return True

def main():
    diff_text = get_diff()
    if diff_text is None:
        return

    if not diff_text.strip():
        print("No changes for commit")
        return

    commit_message = gen_comment(diff_text)

    if input(f"{commit_message}\nContinue with commit? (y/n): ").strip().lower() == 'y':
        if git_commit(commit_message):
            if input("Continue with push? (y/n): ").strip().lower() == 'y':
                git_push()
                print("Done")

if __name__ == "__main__":
    main()
