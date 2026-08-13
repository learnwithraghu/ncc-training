# Docker Hub login — 10 points for the three teams

Username is **`learnwithraghu`**. The instructor tells you the password
(or access token) in class. It is **not** in this repo.

Your team repo (public):

| Team | Repository |
|------|------------|
| Team 1 | `learnwithraghu/ncc-team-1` |
| Team 2 | `learnwithraghu/ncc-team-2` |
| Team 3 | `learnwithraghu/ncc-team-3` |

Class images stay on `learnwithraghu/ncc-workshop` (`:1.0` / `:2.0`).
Push **your** work only to **your** team repo.

1. Docker is installed and `docker info` works.
2. Know your team number. You push only to that team's repo.
3. Username is always `learnwithraghu` — not your GitHub name.
4. Get the login secret from the instructor (Hub access token preferred).
   Do not write it in chat, Slack, git, or a screenshot.
5. Log in:

   ```bash
   docker login -u learnwithraghu
   ```

6. When it asks for **Password**, paste the token (nothing shows as you
   type). Press Enter.
7. You should see `Login Succeeded`. If not, the token is wrong or
   expired — ask the instructor, do not retry a guessed password.
8. Tag your image for **your** repo:

   ```bash
   docker tag myapp:1.0 learnwithraghu/ncc-team-1:1.0
   ```

   Change `ncc-team-1` to `ncc-team-2` or `ncc-team-3` for your team.
9. Push, then confirm Hub shows the tag:

   ```bash
   docker push learnwithraghu/ncc-team-1:1.0
   ```

10. When you are done: `docker logout`. Never commit a password or
    `~/.docker/config.json` into git.

Pulling `learnwithraghu/ncc-workshop:1.0` for the Kubernetes lab does
**not** need login. Login is only for **push** to a team repo.
