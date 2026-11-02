-dash =
    { IS_MINIMAL() ->
        [yes] -
       *[no] —
    }
-bullet =
    { IS_MINIMAL() ->
        [yes] -
       *[no] •
    }

help-arg-remote = The local git remote that points to the repo to operate on
help-arg-repo = The repo to operate on

msg-repo_not_found = Could not find the specified repo

msg-whoami = currently signed into {$name}@{$host}

help-cmd-auth-login = Log in to an instance
help-cmd-auth-login-long =
    Log in to an instance

    Opens an auth page in your browser
msg-auth-login-oauth_unsupported =
  Your installation of forge doesn't support `login` for {$host_domain}

  Please visit {$applications_url}
  to create a token, and use it to log in with `forge auth add-key`
msg-auth-login-canceled = Login canceled
msg-auth-login-browser_success = Authenticated! Close this tab and head back to your terminal.
msg-auth-login-browser_failure = Failed to authenticate.

help-cmd-auth-logout = Deletes login info for an instance
msg-auth_logout-success = signed out of {$host}
msg-auth_logout-already_signed_out = already not signed in to {$host}

help-cmd-auth-use_ssh = Enable or disable using SSH by default for certain instances
msg-auth-use_ssh-not_logged_in = not logged in to {$host}
msg-auth-use_ssh-enabled = now will use SSH for {$host} by default
msg-auth-use_ssh-disabled = will no longer use SSH for {$host} by default
msg-auth-use_ssh-already_enabled = already using SSH for {$host} by default
msg-auth-use_ssh-already_disabled = already not using SSH for {$host} by default

help-cmd-auth-add_token = Add an application token for an instance
help-cmd-auth-add_token-long =
    Add an application token for an instance

    Use this if `forge auth login` doesn't work.
help-arg-auth-add_token-token = The key to add. If not present, the key will be read in from stdin
msg-auth-add_token-prompt = new key:
msg-auth-add_token-already_exists = key for {$host} already exists

help-cmd-auth-list = List all instances you're currently logged into
msg-auth-list-none = No logins.

help-cmd-actions-tasks = List the tasks on a repo
help-arg-actions-tasks-page = The page to show. One page always includes up to 20 tasks

help-cmd-actions-variables = List and manage variables

help-cmd-actions-variables-list = List variables
help-arg-actions-variables-list-verbose = Also print owner_id and repo_id

help-cmd-actions-variables-create = Create a new variable
help-arg-actions-variables-create-name = The name of the new variable
help-arg-actions-variables-create-data = The data to save into the variable. Omit to invoke editor
help-arg-actions-variables-create-force = Override existing variables
msg-actions-variable-create-already_exists = variable already exists, pass --force to replace it.
msg-actions-variable-create-already_exists_forced = variable already exists, updating.

help-cmd-actions-variables-delete = Delete a variable
help-arg-actions-variables-delete-name = The variable to delete
msg-actions-variable-delete-success = Variable {$name} deleted.

help-cmd-actions-dispatch = Dispatch a workflow
help-arg-actions-dispatch-name = Name of the workflow to dispatch
help-arg-actions-dispatch-ref = Git revision to dispatch the workflow on
help-arg-actions-dispatch-inputs = Values to give as inputs to the run
msg-actions-dispatch-success = Dispatched workflow {$name} in {$ref} with {$n_inputs ->
        [one] 1 input
       *[other] {$n_inputs} inputs
    }.

help-cmd-actions-secrets = List and manage secrets

help-cmd-actions-secrets-list = List secrets

help-cmd-actions-secrets-create = Create a new actions secret
help-arg-actions-secrets-create-name = The name of the new secret
help-arg-actions-secrets-create-data = The data to save into the secret

help-cmd-actions-secrets-delete = Delete an actions secret
help-arg-actions-secrets-delete-name = The secret to delete

help-arg-json = Print JSON instead of text. Give a comma-separated list of fields to keep only those
msg-json-unknown-field = Unknown JSON field {$field}. Available fields: {$available}
msg-json-diff = --json is not supported for diffs; use `forge pr view diff`

help-cmd-run = View, watch, rerun and cancel Actions runs, and read their logs
help-cmd-run-list = List recent runs
help-arg-run-list-status = Only runs with this status
help-arg-run-list-branch = Only runs on this branch
help-arg-run-list-event = Only runs triggered by this event, e.g. push or pull_request
help-arg-run-list-workflow = Only runs of this workflow file, e.g. ci.yml
help-arg-run-list-commit = Only runs for this commit
help-arg-run-list-limit = How many runs to list
help-cmd-run-view = Show a run and its jobs, or their logs
help-cmd-run-view-long =
    Show a run and its jobs, or their logs.

    --log prints the log of every step, each under a "=== job / step" header. --log-failed prints only the steps that failed, which is usually what explains a red check.
help-arg-run-run = The run number shown in the web UI, or a run or job URL
help-arg-run-job = Only this job, by name or job id
help-arg-run-view-log = Print the logs of the jobs
help-arg-run-view-log_failed = Print the logs of the failed steps of failed jobs
help-cmd-run-watch = Wait for a run to finish; exits nonzero unless it succeeded
help-arg-run-watch-interval = Seconds between checks
help-cmd-run-rerun = Rerun a run, its failed jobs or one job
help-arg-run-rerun-failed = Rerun only the failed and cancelled jobs
help-cmd-run-cancel = Cancel a run
msg-run-invalid-ref = Not a run number or run URL: {$run}
msg-run-not_found = There is no run #{$number}
msg-run-job-not_found = There is no job {$job}. Jobs: {$jobs}
msg-run-job-out_of_range = There is no job {$position}, the run has {$count}
msg-run-rerun-none = There are no failed jobs to rerun
msg-run-watch-not_success = The run finished with status {$status}

help-cmd-api = Make an authenticated request to the Forgejo API and print the response
help-arg-api-endpoint = The endpoint, relative to /api/v1/, or a full URL on the same host. {"{"}owner{"}"} and {"{"}repo{"}"} are replaced with the current repo
help-arg-api-method = The HTTP method. Defaults to GET, or POST when fields or --input are given
help-arg-api-field = Add a typed field: true, false, null and integers become JSON, @file reads a file (@- reads stdin). key[sub] nests an object, key[] appends to an array
help-arg-api-raw-field = Add a field whose value is always a string
help-arg-api-header = Add a request header
help-arg-api-input = Send this file as the request body (- reads stdin). Fields then go in the query string
help-arg-api-paginate = Follow every page of the result and print one combined JSON array
help-arg-api-include = Print the response status and headers before the body
help-arg-api-silent = Do not print the response body
msg-api-invalid-method = Invalid HTTP method: {$method}
msg-api-invalid-header = Invalid header, expected KEY:VALUE: {$header}
msg-api-invalid-field = Invalid field, expected KEY=VALUE: {$field}
msg-api-field-conflict = Field {$field} conflicts with an earlier field
msg-api-nested-query = Field {$field} is an object or a nested array, which can't go in a query string
msg-api-no-repo = The endpoint uses {"{"}owner{"}"} or {"{"}repo{"}"}, but no repo was found. Try specifying it with `--repo`
msg-api-other-host = Refusing to send the token to a host other than {$host}
msg-api-status = HTTP {$status}

help-cmd-org-list = List all organizations
help-arg-org-list-page = Which page of the results to view
help-arg-org-list-only_member_of = Only list organizations you are a member of
msg-org-list-no_results = No results.
msg-org-list-page_number = Page {$page} of {$total}

help-cmd-org-view = View info about an organization
help-arg-org-view-name = The name of the organization to view
msg-org-view-org_name = { OPT($full_name) ->
       *[none] {STYLE("bold", "bright-cyan")}{$name}{STYLE("reset")}
        [some] {STYLE("bold", "bright-cyan")}{$full_name}{STYLE("reset")} {STYLE("light-gray")}({$name}){STYLE("reset")}
    }
msg-org-view-visibility = { $visibility ->
        [public] Public
        [limited] Limited
       *[private] Private
    }
msg-org-view-member_count = {$member_count ->
        [one] {STYLE("bold")} 1 {STYLE("reset")} member
       *[other] {STYLE("bold")}{$member_count}{STYLE("reset")} members
    }
msg-org-view-team_count = {$team_count ->
        [one] {STYLE("bold")} 1 {STYLE("reset")} team
       *[other] {STYLE("bold")}{$team_count}{STYLE("reset")} teams
    }

help-arg-org-options-full_name = The display name for the organization
help-arg-org-options-full_name-long =
    The display name for the organization

    This doesn't have the restrictions the `name` argument does, and can contain any UTF-8 text.
help-arg-org-options-description = The organization's description
help-arg-org-options-email = Contact email for the organization
help-arg-org-options-location = The organizations's location
help-arg-org-options-website = The organization's website
help-arg-org-options-visibility = The visibility of the organization
help-arg-org-options-visibility-long =
    The visibility of the organization

    Public organizations can be viewed by anyone, limited orgs can only be viewed by
    logged-in users, and private orgs can only be viewed by members of that org.
help-arg-org-options-admin_can_change_team_access = Whether the admin of a repo can change org teams' access to it

help-cmd-org-create = Create a new organization
help-arg-org-create-name = The username for the organization
help-arg-org-create-name-long =
    The username for the organization

    It can only have alphanumeric characters, dash, underscore, or period. It must start
    and end with an alphanumeric character, and can't have consecutive dashes, underscores,
    or periods.

    If you want a name that doesn't have these restrictions, see the `--full-name` option.
msg-org-create-invalid_character =
    Organization names can only have alphanumeric characters, dashes, underscores, or periods.
      If you want a name with other characters, try setting the --full-name flag
msg-org-create-invalid_starting_character =
    Organization names can only start with alphanumeric characters.
      If you want a name that starts with other characters, try setting the --full-name flag
msg-org-create-invalid_ending_character =
    Organization names can only end with alphanumeric characters.
      If you want a name that ends with other characters, try setting the --full-name flag
msg-org-create-invalid_consecutive_characters =
    Organization names can't have consecutive non-alphanumeric characters.
      If you want that in the name, try setting the --full-name flag
msg-org-create-success = created new {$visibility ->
        [public] public
        [limited] limited
       *[private] private
    } org { OPT($full_name) ->
       *[none] {STYLE("bold", "bright-cyan")}{$name}{STYLE("reset")}
        [some] {STYLE("bold", "bright-cyan")}{$full_name}{STYLE("reset")} {STYLE("light-gray")}({$name}){STYLE("reset")}
    }

help-cmd-org-edit = Edit an organization's information
help-arg-org-edit-name = The name of the organization to edit
help-arg-org-edit-name-long =
    The name of the organization to edit

    Note that this is the username, *not* the display name.

help-cmd-org-activity = View the activity in an organization
help-arg-org-activity-name = The name of the organization to view activity for

help-cmd-org-members = List the members of an organization
help-arg-org-members-org = The name of the organization to view the members of
help-arg-org-members-page = Which page of the results to view
msg-org-members-no_results = No results.
msg-org-members-page_number = Page {$page} of {$total}
msg-org-members-entry = { OPT($full_name) ->
       *[none] {STYLE("bold", "bright-cyan")}{$username}{STYLE("reset")}
        [some] {STYLE("bold", "bright-cyan")}{$full_name}{STYLE("reset")} {STYLE("light-gray")}({$username}){STYLE("reset")}
    }

help-cmd-org-visibility = View and change the visibility of your membership in an organization
help-arg-org-visibility-org = The name of the organization to view your visibility in
help-arg-org-visibility-set = Set a new visibility for yourself
msg-org-visibility-public = You are a public member of {STYLE("bold", "bright-cyan")}{$org_name}{STYLE("reset")}
msg-org-visibility-private = You are a private member of {STYLE("bold", "bright-cyan")}{$org_name}{STYLE("reset")}
msg-org-visibility-set_public = You are now a public member of {STYLE("bold", "bright-cyan")}{$org_name}{STYLE("reset")}
msg-org-visibility-set_private = You are now a private member of {STYLE("bold", "bright-cyan")}{$org_name}{STYLE("reset")}
msg-org-visibility-not_member = You are not a member of {STYLE("bold", "bright-cyan")}{$org_name}{STYLE("reset")}

help-cmd-org-label-list = List all the issue labels an organization uses
help-arg-org-label-list-org = The name of the organization to list the labels of

help-cmd-org-label-add = Add a new issue label to an organization
help-arg-org-label-add-org = The name of the organization the label should be added to
help-arg-org-label-add-name = The name of the label to add
help-arg-org-label-add-color = The hexcode of the label to add
help-arg-org-label-add-description = A description of what the label is for
help-arg-org-label-add-exclusive = If this label is named {"`{scope}/{name}`"}, make it exclusive with other labels with the same scope
msg-org-label-add-success = Created new label {$label}

help-cmd-org-label-edit = Edit an issue label an organization uses
help-arg-org-label-edit-org = The name of the organization the label is in
help-arg-org-label-edit-name = The name of the label to edit
help-arg-org-label-edit-new_name = Set a new name for the label
help-arg-org-label-edit-color = Set a new hexcode for the label
help-arg-org-label-edit-description = Set a description of what the label is for
help-arg-org-label-edit-exclusive = Set whether this label is exclusive with others of the same scope
help-arg-org-label-edit-archived = Set whether this label is archived
msg-org-label-edit-success = Changed label {$old_label} to {$label}

help-cmd-org-label-rm = Remove an issue label from an organization
help-arg-org-label-rm-org = The name of the organization the label is in
help-arg-org-label-rm-label = The name of the label to remove from the organization
msg-org-label-remove-success = Removed label {$label}

help-cmd-org-repo-list = List all the repos owned by this organization
help-arg-org-repo-list-org = The name of the organization to list the repos of
help-arg-org-repo-list-page = Which page of the results to view
msg-org-repo-list-no_results = No results.
msg-org-repo-list-page_number = Page {$page} of {$total}

help-cmd-org-repo-create = Create a new repository in this organization
help-arg-org-repo-create-org = The name of the organization to create the repo in

help-cmd-org-team-list = View all the teams in an organization
help-arg-org-team-list-org = The name of the organization to list the teams in

help-cmd-org-team-view = View info about a single team
help-arg-org-team-view-org = The name of the organization the team is part of
help-arg-org-team-view-name = The name of the team to view
msg-org-team-view = {STYLE("bright-blue", "bold")}{$name}{STYLE("reset")} in org {STYLE("bold")}{$org}{STYLE("reset")} {$admin ->
        [yes] {-dash} {STYLE("bright-red")}Admin{STYLE("reset")}
       *[no] {""}
    }
msg-org-team-view-read_only = Read Only:
msg-org-team-view-read_write = Read/Write:
msg-org-team-view-perms-wiki = Wikis
msg-org-team-view-perms-ext_wiki = External Wikis
msg-org-team-view-perms-issues = Issues
msg-org-team-view-perms-ext_issues = External Issues
msg-org-team-view-perms-pulls = Pull Requests
msg-org-team-view-perms-projects = Projects
msg-org-team-view-perms-actions = CI
msg-org-team-view-perms-code = Code
msg-org-team-view-perms-releases = Releases
msg-org-team-view-perms-packages = Packages

help-arg-org-team-options-description = A description of what the team does
help-arg-org-team-options-read_permissions = A comma-separated list of read permissions to give this team
help-arg-org-team-options-read_permissions-long =
    A comma-separated list of read permissions to give this team

    List of permissions:
     - wiki
     - ext_wiki
     - issues
     - ext_issues
     - pulls
     - projects
     - actions
     - code
     - releases
     - packages

    Alternatively, you can use `all` to allow every read permission.
help-arg-org-team-options-write_permissions = A comma-separated list of read+write permissions to give this team
help-arg-org-team-options-write_permissions-long =
    A comma-separated list of read+write permissions to give this team

    List of permissions:
     - wiki
     - ext_wiki
     - issues
     - ext_issues
     - pulls
     - projects
     - actions
     - code
     - releases
     - packages

    Alternatively, you can use `all` to allow every read+write permission

help-cmd-org-team-create = Create a new team
help-arg-org-team-create-org = The name of the organization to create the team in
help-arg-org-team-create-name = The name of the new team
help-arg-org-team-create-name-long =
    The name of the new team

    This must only contain alphanumeric characters
help-arg-org-team-create-can_create_repos = Allow members of this team to create repos in the organization
help-arg-org-team-create-include_all_repos = Give this team access to every repo
help-arg-org-team-create-admin = Give this team administrator abilities in the organization
msg-org-team-create-success = created new {$admin ->
        [yes] admin
       *[no] {""}
    } team {STYLE("bright-blue", "bold")}{$name}{STYLE("reset")} in org {STYLE("bold")}{$org}{STYLE("reset")}

help-cmd-org-team-edit = Edit a team's information and permissions
help-arg-org-team-edit-org = The name of the organization the team is in
help-arg-org-team-edit-name = The name of the team to edit
help-arg-org-team-edit-can_create_repos = Allow members of this team to create repos in the organization
help-arg-org-team-edit-include_all_repos = Give this team access to every repo
help-arg-org-team-edit-admin = Give this team administrator abilities in the organization

help-cmd-org-team-delete = Delete a team from an organization
help-cmd-org-team-delete-long =
    Delete a team from an organization

    Note that this does NOT delete the repos the team has!
help-arg-org-team-delete-org = The name of the organization the team is in
help-arg-org-team-delete-name = The name of the team to delete
msg-org-team-delete-confirmation = Are you sure you want to delete {STYLE("bold")}{$org}/{$name}{STYLE("reset")}?
    .yes =
        Yes
        yes
        Y
        y
    .no =
        No
        no
        N
        n

help-cmd-org-team-repo-list = List all the repos this team can access
help-arg-org-team-repo-list-org = The name of the organization the team is in
help-arg-org-team-repo-list-team = The name of the team to view the repos of
help-arg-org-team-repo-list-page = Which page of the results to view
msg-org-team-repo-list-no_results = No results.
msg-org-team-repo-list-page_number = Page {$page} of {$total}

help-cmd-org-team-repo-add = Add access to an existing repo to a team
help-arg-org-team-repo-add-org = The name of the organization the team is in
help-arg-org-team-repo-add-team = The name of the team to add a repo to
help-arg-org-team-repo-add-repo = The name of the repo to add to the team
msg-org-team-repo-add-success =
    Added {STYLE("bold")}{$org}/{$repo}{STYLE("reset")} to team {STYLE("bold", "bright-blue")}{$team}{STYLE("reset")}

help-cmd-org-team-repo-rm = Remove access to a repo from a team
help-cmd-org-team-repo-rm-long =
    Remove access to a repo from a team

    Note that this does NOT delete the repository!
help-arg-org-team-repo-rm-org = The name of the organization the team is in
help-arg-org-team-repo-rm-team = The name of the team to remove the repo from
help-arg-org-team-repo-rm-repo = The name of the repo to remove from the team
msg-org-team-repo-rm-success =
    Removed {STYLE("bold")}{$org}/{$repo}{STYLE("reset")} from team {STYLE("bold", "bright-blue")}{$team}{STYLE("reset")}

help-cmd-org-team-member-list = List all the members of a team
help-arg-org-team-member-list-org = The name of the organization the team is in
help-arg-org-team-member-list-team = The name of the team to view the members of
help-arg-org-team-member-list-page = Which page of the results to view
msg-org-team-member-list-no_results = No results.
msg-org-team-member-list-page_number = Page {$page} of {$total}

help-cmd-org-team-member-add = Add someone to a team
help-arg-org-team-member-add-org = The name of the organization the team is in
help-arg-org-team-member-add-team = The name of the team to add a user to
help-arg-org-team-member-add-user = The name of the user to add to the team
msg-org-team-member-add-success =
    Added {STYLE("bold", "bright-cyan")}{$user}{STYLE("reset")} to team {STYLE("bold", "bright-blue")}{$team}{STYLE("reset")}

help-cmd-org-team-member-rm = Remove someone from a team
help-arg-org-team-member-rm-org = The name of the organization the team is in
help-arg-org-team-member-rm-team = The name of the team to remove the user from
help-arg-org-team-member-rm-user = The name of the user to remove from the team
msg-org-team-member-rm-success =
    Removed {STYLE("bold", "bright-cyan")}{$user}{STYLE("reset")} from team {STYLE("bold", "bright-blue")}{$team}{STYLE("reset")}

help-cmd-issue-create = Create a new issue on a repo
help-arg-issue-create-title = Title of the issue
help-arg-issue-create-body = The text body of the issue
help-arg-issue-create-body-long =
    The text body of the issue

    Leaving this out will open your editor, unless --body-file is specified.
help-arg-issue-create-body_file = The file to read the text body of the issue from
help-arg-issue-create-template = The template to use when creating an issue
help-arg-issue-create-template-long =
    The template to use when creating an issue

    If the repo has disabled blank issues, this flag is required.
help-arg-issue-create-no_template = Don't use a template for this issue
help-arg-issue-create-no_template-long =
    Don't use a template for this issue

    If the repo has disabled blank issues, this will fail.
help-arg-issue-create-milestone = Add this issue to the given milestone
help-arg-issue-create-repo = The repo to create this issue on
help-arg-issue-create-web = Open the issue creation page in your web browser
msg-issue-create-no_templates = {$owner}/{$repo} does not have any issue templates
msg-issue-create-templates_required =
    {$owner}/{$repo} requires using a template.
    Please choose one with `--template <NAME>`.
msg-issue-create-templates_enabled =
    {$owner}/{$repo} uses issue templates.
    Please choose one with `--template <NAME>`,
    or use `--no-template` to write one from scratch".
msg-issue-create-success = created issue #{$number}: {$title}

help-cmd-issue-view = View an issue's info
help-arg-issue-view-issue = The issue to view
help-cmd-issue-view-body = View an issue's title and body. The default
msg-issue-view-header =
    {STYLE("yellow")}{$title} {STYLE("dark-grey")}#{$number}{STYLE("reset")}"
    By {STYLE("white")}{$author}{STYLE("reset")} {-dash} {$state ->
        [open] {STYLE("bright-green")}Open{STYLE("reset")}
        [closed] {STYLE("bright-red")}Closed{STYLE("reset")}
       *[other] $state
    }
msg-issue-view-comment_count = { $comments ->
        [one] 1 comments
       *[other] {$comments} comments
    }

help-cmd-issue-view-comment = View a specific comment

help-cmd-issue-view-comments = List every comment

help-cmd-issue-view-assignees = List the users assigned to this issue
msg-view-assignees-header = Assigned to ({ $count ->
        [one] 1 user
       *[other] {$count} users
    }):
msg-view-assignees-entry = { OPT($full_name) ->
       *[none] {-bullet} {$login}
        [some] {-bullet} {$full_name} {STYLE("dark-grey")}({$login}){STYLE("reset")}
    }
msg-view-assignees-empty = No one is assigned.

help-cmd-issue-search = Search for an issue in a repo
help-arg-issue-search-repo = The repo to search in
help-arg-issue-search-state = Filter issues by state. Default: open
help-arg-issue-search-all = Display all issues
msg-issue-search-page-total = { $total_pages ->
        [one] {$issues ->
            [one] 1 issue
           *[other] {$issues} issues
        }
       *[other] Page {$page} out of {$total_pages} pages in total ({$issues ->
            [one] 1 issue
           *[other] {$issues} issues
       })
    }
help-arg-issue-search-milestones = Comma-separated list of milestones to filter by
msg-issue-search-entry = #{$number}: {$title} (by {$author})

help-cmd-issue-templates = List the issue templates in a repo
help-arg-issue-templates-repo = The repo to view the templates of
msg-issue-templates-none = No issue templates or contact info.
msg-issue-templates-blank_allowed = '--no-template' is allowed
msg-issue-templates-blank_not_allowed = '--no-template' is not allowed

msg-issue-view-comments-comment_header = { OPT($full_name) ->
       *[none] {STYLE("bold", "bright-cyan")}{$username}{STYLE("reset")} said:
        [some] {STYLE("bold", "bright-cyan")}{$full_name}{STYLE("reset")} {STYLE("dark-gray")}({$username}){STYLE("reset")} said:
    }
msg-issue-view-comments-attachments = { $attachments ->
        [one] 1 attachment
       *[other] {$attachments} attachments
    }

help-cmd-issue-edit = Edit an issue

help-cmd-issue-edit-title = Edit an issue's title
msg-issue-edit-title-empty = title cannot be empty
msg-issue-edit-title-no_newlines = title cannot contain newlines

help-cmd-issue-edit-body = Edit an issue's text content

help-cmd-issue-edit-comment = Edit a comment on an issue

help-cmd-issue-edit-labels = Edit an issue's labels
help-arg-issue-edit-labels-add = The labels to add
help-arg-issue-edit-labels-rm = The labels to remove

help-cmd-issue-edit-milestone = Edit an issue's milestone

help-cmd-issue-comment = Add a comment on an issue
help-arg-issue-comment-issue = The issue to comment on
help-arg-issue-comment-body = The text content of the comment
help-arg-issue-comment-body-long =
    The text content of the comment

    Leaving this out will open your editor, unless --body-file is specified.
help-arg-issue-comment-body_file = The file to read the text content of the comment from

help-cmd-issue-assign = Assign users to an issue
help-arg-issue-assign-issue = The issue to assign users to
help-arg-issue-assign-users = The usernames of the users to assign to this issue
msg-issue-assign-success =
    assigned {$added ->
        [one] 1 user
       *[other] {$added} users
    } to {$owner}/{$repo}#{$number} {$duplicate ->
        [0] {""}
        [one] {$added ->
            [0] (user was already assigned)
           *[other] (1 user was already assigned)
        }
       *[other] {$added ->
            [0] (all users were already assigned)
           *[other] ({$duplicate} users were already assigned)
        }
    }

help-cmd-issue-unassign = Unassign users from an issue
help-arg-issue-unassign-issue = The issue to unassign users from
help-arg-issue-unassign-users = The usernames of the users to unassign from this issue
msg-issue-unassign-success =
    unassigned {$removed ->
        [one] 1 user
       *[other] {$removed} users
    } from {$owner}/{$repo}#{$number} {$duplicate ->
        [0] {""}
        [one] {$removed ->
            [0] (user was already not assigned)
           *[other] (1 user was already not assigned)
        }
       *[other] {$removed ->
            [0] (all users were already not assigned)
           *[other] ({$duplicate} users were already not assigned)
        }
    }

help-cmd-issue-close = Close an issue
help-arg-issue-close-issue = The issue to close
help-arg-issue-close-with_msg = A comment to leave on the issue before closing it
msg-issue-close-success = Closed issue #{$number}: "{$title}"

help-cmd-issue-browse = Open an issue in your browser

help-cmd-issue-depend = Manage issues this issue depends on
help-cmd-issue-block = Manage issues this issue blocks

# Shared between `issue` and `pr` depend/block subcommands
help-cmd-depend-add = Add one or more dependencies
help-cmd-depend-remove = Remove one or more dependencies
help-cmd-depend-list = List dependencies

help-cmd-block-add = Add one or more blocking relationships
help-cmd-block-remove = Remove one or more blocking relationships
help-cmd-block-list = List blockers

help-arg-depend-add-target = One or more issues to add as dependencies
help-arg-depend-remove-target = One or more issues to remove from dependencies
help-arg-block-remove-target = One or more issues to unblock

help-arg-issue-depend-add-issue = The issue to operate on
help-arg-issue-depend-remove-issue = The issue to operate on
help-arg-issue-depend-list-issue = The issue whose dependencies to list

help-arg-issue-block-add-issue = The issue to operate on
help-arg-issue-block-add-target = One or more issues this issue should block
help-arg-issue-block-remove-issue = The issue to operate on
help-arg-issue-block-list-issue = The issue whose blockers to list

msg-issue-depend-add-success =
    { $count ->
        [one] Added 1 dependency to #{$issue}
       *[other] Added {$count} dependencies to #{$issue}
    }
msg-issue-depend-remove-success =
    { $count ->
        [one] Removed 1 dependency from #{$issue}
       *[other] Removed {$count} dependencies from #{$issue}
    }
msg-issue-block-add-success =
    { $count ->
        [one] Added 1 blocking relationship from #{$issue}
       *[other] Added {$count} blocking relationships from #{$issue}
    }
msg-issue-block-remove-success =
    { $count ->
        [one] Removed 1 blocking relationship from #{$issue}
       *[other] Removed {$count} blocking relationships from #{$issue}
    }
msg-issue-dep-target-required = at least one target issue is required
msg-issue-depend-no_repo_info = can't figure what repo to access, try specifying it via `{ "{" }owner{ "}" }/{ "{" }repo{ "}" }#{ "{" }number{ "}" }` on the issue or target arguments
msg-pr-depend-no_repo_info = can't figure what repo to access, try specifying with `--repo`
msg-issue-depend-list-empty = No dependencies.
msg-issue-block-list-empty = No blockers.
msg-issue-depend-list-header = {STYLE("bold")}Dependencies of{STYLE("reset")} {$owner}/{$repo} {-dash} #{$number}
msg-issue-block-list-header = {STYLE("bold")}Issues blocked by{STYLE("reset")} {$owner}/{$repo} {-dash} #{$number}
msg-issue-dep-list-entry = {"  "}#{$number} {STYLE("bold")}{$title}{STYLE("reset")} ({$state ->
        [closed] closed
        [merged] merged
        [draft] draft
       *[open] open
    })

msg-pr-couldnt_guess = could not guess pull request number, please specify
msg-pr-not_found = could not find PR


help-cmd-pr-view = View the contents of a pull request
help-arg-pr-view-id = The pull request to view

help-cmd-pr-view-body = View the title and body of a pull request
msg-pr-view-header =
    {STYLE("yellow")}{$title} {STYLE("dark-grey")}#{$number}{STYLE("reset")}
    By {STYLE("white")}{$username}{STYLE("reset")} {-dash} {$state ->
        [draft] {STYLE("light-grey")}Draft{STYLE("reset")}
        [open] {STYLE("bright-green")}Open{STYLE("reset")}
        [merged] {STYLE("bright-magenta")}Merged{STYLE("reset")}
        [closed] {STYLE("bright-red")}Closed{STYLE("reset")}
       *[other] $state
    } {-dash} {STYLE("bright-green")}+{$additions} {STYLE("bright-red")}-{$deletions}{STYLE("reset")}
    {OPT($head_branch) ->
       *[none] Into `{$base_branch}`
        [some] From `{$head_branch}` into `{$base_branch}`
    }
msg-pr-view-comment_count = { $comments ->
        [one] 1 comments
       *[other] {$comments} comments
    }

help-cmd-pr-view-comment = View a comment on a pull request
help-arg-pr-view-comment-idx = The index of the comment to view, 0-indexed

help-cmd-pr-view-comments = View all comments on a pull request

help-cmd-pr-view-labels = View the labels applied to a pull request

help-cmd-pr-view-assignees = List the users assigned to this pull request

help-cmd-pr-view-diff = View the diff between the base and head branches of a pull request
help-arg-pr-view-diff-patch = Get the diff in patch format
help-arg-pr-view-diff-editor = View the diff in your text editor
msg-pr-view-diff-volatile = changes made to the diff will not persist

help-cmd-pr-view-files = View the files changed in a pull request

help-cmd-pr-view-commits = View the commits in a pull request
help-arg-pr-view-commits-oneline = View one commit per line

help-cmd-pr-status = View the mergability and CI status of a pull request
help-arg-pr-status-id = The pull request to view
help-arg-pr-status-wait = Wait for all checks to finish before exiting
msg-pr-status-merged = {STYLE("bright-magenta")}Merged{STYLE("reset")} by {$merged_by} on {DATETIME($merged_at, dateStyle: "long", timeStyle: "long")}
msg-pr-status-header = {$state ->
        [draft] {STYLE("light-grey")}Draft{STYLE("reset")} {-dash} Can't merge draft PR
        [open] {STYLE("bright-green")}Open{STYLE("reset")} {-dash} {$mergeable ->
           *[yes] Can be merged
            [no] {STYLE("bright-red")}Merge conflicts{STYLE("reset")}
        }
        [closed] {STYLE("bright-red")}Closed{STYLE("reset")} {-dash} Reopen to merge
       *[other] Unknown
    }
msg-pr-status-entry = {$state ->
        [success] {STYLE("bright-green")}Success{STYLE("reset")}
        [pending] {STYLE("yellow")}Pending{STYLE("reset")}
        [warning] {STYLE("bright-yellow")}Warning{STYLE("reset")}
        [failure] {STYLE("bright-red")}Failure{STYLE("reset")}
        [skipped] {STYLE("grey")}Skipped{STYLE("RESET")}
        [error] {STYLE("bright-red")}Error{STYLE("reset")}
       *[other] Unknown
    } {-dash} {$context}

help-cmd-pr-review = Manage reviews on a pull request
help-arg-pr-review-id = The pull request to act on

help-cmd-pr-review-list = List reviews on a pull request
help-arg-pr-review-list-comments = List inline comments in reviews on a pull request
help-arg-pr-review-list-all = Include all reviews, including stale and dismissed ones
msg-pr-review-list-none = No reviews.
msg-pr-review-list-only_stale = Only stale or dismissed reviews, use --all to display them.
msg-pr-review-list-review_header = {$review_type ->
        [approved] {STYLE("bright-green")}Approved{STYLE("reset")}
        [changes-requested] {STYLE("bright-yellow")}Changes requested{STYLE("reset")}
        [comment] {STYLE("bright-yellow")}Comment{STYLE("reset")}
        [pending] {STYLE("light-grey")}Pending Review{STYLE("reset")}
       *[other] Unknown
    } by {STYLE("bold")}{$reviewer}{STYLE("reset")}
    {STYLE("dark-grey")}{$comments ->
        [one] 1 comment
       *[other] {$comments} comments
    }, made on {DATETIME($timestamp, dateStyle: "long", timeStyle: "short")}{STYLE("reset")} {$state ->
        [stale] {STYLE("bold")}(stale){STYLE("reset")}
        [dismissed] {STYLE("bold")}(dismissed){STYLE("reset")}
       *[other] {""}
    }
msg-pr-review-list-comment_position = In {STYLE("bold")}{$path}:{$position}{STYLE("reset")}:
msg-pr-review-list-comment_header = {STYLE("bold", "bright-cyan")}{$commenter}{STYLE("reset")} commented {OPT($resolver) ->
       *[none] {""}
        [some] (resolved by {$resolver})
    }:

help-cmd-pr-review-submit = Submit a review, optionally with inline comments
help-cmd-pr-review-submit-long =
    Submit a review on a pull request: an approval, a change request or a plain comment (the default).

    Inline comments go on lines of the diff, either with --line and --old-line, which can be repeated, or as a JSON file with --comments-file. The review is pinned to the head commit of the pull request unless --commit is given.
help-arg-pr-review-submit-approve = Approve the pull request
help-arg-pr-review-submit-request_changes = Request changes
help-arg-pr-review-submit-comment = Comment without approving or requesting changes (the default)
help-arg-pr-review-submit-body = The review text
help-arg-pr-review-submit-body_file = Read the review text from a file (- reads stdin)
help-arg-pr-review-submit-line = Comment on a line, or a range, of the new version of a file, e.g. src/main.rs:42=Text or src/main.rs:40-44=Text
help-arg-pr-review-submit-old_line = Like --line, but on the old version of the file, for removed lines
help-arg-pr-review-submit-comments_file = Read inline comments from a JSON file (- reads stdin)
help-arg-pr-review-submit-comments_file-long =
    Read inline comments from a JSON file (- reads stdin), an array of objects like
    {"{"}"path": "src/main.rs", "line": 40, "end_line": 44, "side": "new", "body": "Text"{"}"}.
    end_line is optional, and side is "new" (the default) or "old".
help-arg-pr-review-submit-commit = The commit to review, instead of the head of the pull request
msg-pr-review-submit-invalid_line = Invalid inline comment, expected PATH:LINE=BODY or PATH:START-END=BODY: {$spec}
msg-pr-review-submit-success = {$event ->
        [APPROVED] Approved
        [REQUEST_CHANGES] Requested changes on
       *[other] Reviewed
    } #{$number}{$comments ->
        [0] {""}
        [one] {" "}with 1 inline comment
       *[other] {" "}with {$comments} inline comments
    }: {$url}

help-cmd-pr-review-request = Request reviewer on a pull request
help-arg-pr-review-request-reviewers = The usernames of the users to request a review from
help-arg-pr-review-request-team = The team names to request a review from
msg-pr-review-request-success = Requested reviews on #{$number}

help-cmd-pr-create = Create a new pull request
help-arg-pr-create-base = The branch to merge onto
help-arg-pr-create-head = The branch to pull changes from
help-arg-pr-create-title = What to name the new pull request
help-arg-pr-create-title-long =
    What to name the new pull request

    Prefix with "WIP: " to mark this PR as a draft.
help-arg-pr-create-body = The text body of the pull request
help-arg-pr-create-body-long =
    The text body of the pull request

    Leaving this out will open your editor, unless --body-file is specified.
help-arg-pr-create-body_file = The text body of the issue, to read from a file
help-arg-pr-create-autofill = Automatically populate the PR's title and body from its commits
help-arg-pr-create-autofill-long =
    Automatically populate the PR's title and body from its commits

    If there's a single commit, the PR will match its title and contents.
    Otherwise the title will be the branch title, and the contents will
    include a list of every commit's message.
help-arg-pr-create-repo = The repo to create this pull request on
help-arg-pr-create-web = Open the PR creation page in your web browser
help-arg-pr-create-agit = Open the PR using AGit workflow
help-arg-pr-create-milestone = Add this PR to the given milestone
msg-pr-create-cross_instance = cannot create pull request across instances; base is on {$base_instance}, while head is tracking {$head_instance}
msg-pr-create-success = created pull request #{$number}: {$title}
msg-pr-create-agit_success = created pull request: {$title}
msg-pr-create-agit_push_cfg_question =
    Would you like to set the needed git config
    items so that `git push` works for this pr?
msg-pr-create-agit_push_cfg_prompt = (y/N/?)
    .yes =
        Yes
        yes
        Y
        y
    .no =
        No
        no
        N
        n
    .help =
        Help
        help
        H
        h
        ?
msg-pr-create-agit_force_push_warning =
    {STYLE("bold")}Note:{STYLE("reset")}
      `git push --force[-with-lease]` is not supported for AGit PRs.
      You can use `git push -o force=true` instead.
msg-pr-create-agit_push_cfg_help = This would set the following config options:

help-cmd-pr-merge = Merge a pull request
help-arg-pr-merge-pr = The pull request to merge
help-arg-pr-merge-method = The merge style to use
help-arg-pr-merge-delete = Option to delete the corresponding branch afterwards
help-arg-pr-merge-title = The title of the merge or squash commit to be created
help-arg-pr-merge-message = The body of the merge or squash commit to be created
msg-pr-merge-commit_title_unsupported-rebase = rebase does not support commit title
msg-pr-merge-commit_title_unsupported-ff = ff-only does not support commit title
msg-pr-merge-commit_title_unsupported-manual = manually merged does not support commit title
msg-pr-merge-default_message = Reviewed-on: {$pr_url}
msg-pr-merge-success = Merged PR #{$number} \"{$title}\" into `{$base_branch}`

help-cmd-pr-checkout = Checkout a pull request in a new branch
help-arg-pr-checkout-pr = The pull request to check out
help-arg-pr-checkout-pr-long =
    The pull request to check out

    Prefix with ^ to get a pull request from the parent repo.
help-arg-pr-checkout-branch_name = The name to give the newly created branch
help-arg-pr-checkout-branch_name-long =
    The name to give the newly created branch

    Defaults to naming after the host url, repo owner, and PR number.
help-arg-pr-checkout-ssh = Pull the commits using SSH instead of HTTP(S)
help-arg-pr-checkout-identity_file = An SSH key file to use when cloning over SSH
msg-pr-checkout-dirty = Cannot checkout PR; working directory has uncommitted changes
msg-pr-checkout-not_fork = cannot get parent repo, {$repo} is not a fork
msg-pr-checkout-success = Checked out PR #{$number}: {$title}
    {$new_branch ->
       *[yes] On new branch {$branch_name}
        [no] Updated branch to latest commit
    }

help-cmd-pr-comment = Add a comment on a pull request
help-arg-pr-comment-pr = The pull request to comment on
help-arg-pr-comment-body = The text content of the comment
help-arg-pr-comment-body-long =
    The text content of the comment

    Leaving this out will open your editor, unless --body-file is specified.
help-arg-pr-comment-body_file = The file to read the text content of the comment from

help-cmd-pr-assign = Assign users to a pull request
help-arg-pr-assign-users = The usernames of the users to assign to this PR

help-cmd-pr-unassign = Unassign users from a pull request
help-arg-pr-unassign-users = The usernames of the users to unassign from this PR

help-cmd-pr-depend = Manage issues this pull request depends on
help-cmd-pr-block = Manage issues this pull request blocks

help-arg-pr-depend-add-pr = The pull request to operate on
help-arg-pr-depend-remove-pr = The pull request to operate on
help-arg-pr-depend-list-pr = The pull request whose dependencies to list

help-arg-pr-block-add-pr = The pull request to operate on
help-arg-pr-block-add-target = One or more issues this pull request should block
help-arg-pr-block-remove-pr = The pull request to operate on
help-arg-pr-block-list-pr = The pull request whose blockers to list

help-cmd-pr-edit = Edit the contents of a pull request
help-arg-pr-edit-pr = The pull request to edit

help-cmd-pr-edit-title = Edit the title
help-arg-pr-edit-title-new_title = New PR title
help-arg-pr-edit-title-new_title-long =
    New PR title

    Leaving this out will open the current title in your editor.

help-cmd-pr-edit-body = Edit the text body
help-arg-pr-edit-body-new_body = New PR body
help-arg-pr-edit-body-new_body-long =
    New PR body

    Leaving this out will open the current body in your editor.

help-cmd-pr-edit-comment = Edit a comment
help-arg-pr-edit-comment-idx = The index of the comment to edit, 0-indexed
help-arg-pr-edit-comment-new_body = New comment body
help-arg-pr-edit-comment-new_body-long =
    New comment body

    Leaving this out will open the current body in your editor.

help-cmd-pr-edit-labels = Edit the applied labels
help-arg-pr-edit-labels-add = The labels to add
help-arg-pr-edit-labels-rm = The labels to remove

help-cmd-pr-edit-milestone = Edit a PR's milestone

help-cmd-pr-close = Close a pull request, without merging
help-arg-pr-close-pr = The pull request to close
help-arg-pr-close-with_msg = A comment to add before closing
help-arg-pr-close-with_msg-long =
    A comment to add before closing

    Adding without an argument will open your editor

help-cmd-pr-browse = Open a pull request in your browser
help-arg-pr-browse-id = The pull request to open in your browser

help-cmd-pr-search = Search a repository's pull requests
help-arg-pr-search-state = Filter PRs by state. Default: open
help-arg-pr-search-repo = The repo to search in
help-arg-pr-search-all = Display all pull requests
help-arg-pr-search-milestones = Comma-separated list of milestones to filter by
msg-pr-search-page-argument-error = expected a positive integer
msg-pr-search-page-total = { $total_pages ->
        [one] {$pull_requests ->
            [one] 1 pull request
           *[other] {$pull_requests} pull requests
        }
       *[other] Page {$page} out of {$total_pages} pages in total ({$pull_requests ->
            [one] 1 pull request
           *[other] {$pull_requests} pull requests
       })
    }
msg-pr-search-entry = #{$number}: {$title} (by {$author})

msg-repo-no_host_given = cannot find repo, no host specified
msg-repo-no_info_given =
    no repo info specified

    If you're trying to operate on a repository in the current directory, try adding a remote
    referencing the forgejo instance. If you have multiple remotes, try setting one as upstream to the
    current branch. You may also specify a host explicitly using the `--host` argument.

msg-repo-fallback_host-invalid_url = warn: `FJ_FALLBACK_HOST` is not set to a valid url

msg-repo-arg_no_owner = repo name should be in the format [HOST/]OWNER/NAME

msg-repo-name_needed = couldn't get repo name, please specify

help-cmd-repo-create = Create a new repository
help-arg-repo-create-remote = Creates a new remote with the given name for the new repo
help-arg-repo-create-push = Pushes the current branch to the default branch on the new repo
help-arg-repo-create-push-long =
    Pushes the current branch to the default branch on the new repo

    Implies `--remote=origin` (setting remote manually overrides this)
help-arg-repo-create-ssh = Use SSH for the new remote instead of HTTP(S)
help-arg-repo-create-format = Specify the repository's object format. Default: sha1
msg-repo-create-remote_exists = A remote named \"{$remote_name}\" already exists
msg-repo-create-success = created new repo at {$url}
msg-repo-create-detached_head = HEAD is not on a branch; cannot push to remote
msg-repo-create-branch_invalid_utf8 = branch name invalid utf-8

help-cmd-repo-fork = Fork a repository onto your account
msg-repo-fork-conflicting_hosts = conflicting hosts {$host_a} and {$host_b}. please only specify one
msg-repo-fork-success = Forked {$parent_owner}/{$parent_name} into {$fork_name}

help-cmd-repo-migrate = Migrate or mirror an existing repository
help-arg-repo-migrate-repo = URL of the repo to migrate
help-arg-repo-migrate-name = Name of the new mirror, and optionally which org/user should own it
help-arg-repo-migrate-mirror = Whether to mirror the repo instead of migrating it
help-arg-repo-migrate-private = Whether the new migration should be private
help-arg-repo-migrate-include = Comma-separated list of items to include. Defaults to nothing but git data
help-arg-repo-migrate-include-long =
    Comma-separated list of items to include. Defaults to nothing but git data

    These are `lfs`, `wiki`, `issues`, `prs`, `milestones`, `labels`, and `releases`.
    You can use `all` to include everything.

help-arg-repo-migrate-lfs_endpoint = The URL to fetch LFS files from
help-arg-repo-migrate-service = The type of Git service the original repo is on. Defaults to `git`
help-arg-repo-migrate-token = If enabled, will read an access token in from stdin to use for fetching
help-arg-repo-migrate-token-long =
    If enabled, will read an access token in from stdin to use for fetching

    Mutually exclusive with `--login`
help-arg-repo-migrate-login = If enabled, will read a username and password from stdin to use for fetching
help-arg-repo-migrate-login-long =
    If enabled, will read a username and password from stdin to use for fetching

    Mutually exclusive with `--token`.

    This is not recommended, `--token` should be used instead whenever possible.
msg-repo-migrate-git_only = Migrating from a `git` service doesn't support migration items other than LFS. Please specify a different service or remove the included items
msg-repo-migrate-username_prompt = Username:
msg-repo-migrate-password_prompt = Password:
msg-repo-migrate-token_prompt = Token:
msg-repo-migrate-migrating = Migrating...
msg-repo-migrate-success = Done! View online at {$url}

help-cmd-repo-view = View a repo's info
msg-repo-view-name = {$repo_name}
msg-repo-view-is_fork = Fork of {$parent}
msg-repo-view-is_mirror = Mirror of {$mirror_of}
msg-repo-view-primary_language = Primary language is {$language}
msg-repo-view-stars = {$stars ->
        [one] 1 star
       *[other] {$stars} stars
    }
msg-repo-view-watching = {$watching} watching
msg-repo-view-forks = {$forks ->
        [one] 1 fork
       *[other] {$forks} forks
    }
msg-repo-view-issues = {$issues ->
        [one] 1 issue
       *[other] {$issues} issues
    }
msg-repo-view-prs = {$pull_requests ->
        [one] 1 PR
       *[other] {$pull_requests} PRs
    }
msg-repo-view-releases = {$releases ->
        [one] 1 release
       *[other] {$releases} releases
    }
msg-repo-view-external_tracker = Issue tracker is at {$url}
msg-repo-view-url = View online at {$url}

help-cmd-repo-readme = View a repo's README
msg-repo-readme-none = Repo does not have a README

help-cmd-repo-clone = Clone a repo's code locally
help-arg-repo-clone-ssh = Clone the repo over SSH instead of HTTP(S)
help-arg-repo-clone-identity_file = An SSH key file to use when cloning over SSH
msg-repo-clone-preparing = {"   "}Preparing...
msg-repo-clone-downloading = {" "}Downloading... {NUMBER($percent, maximumFractionDigits: 2)}% ({NUMBER($size, maximumFractionDigits: 2)}{$units})
msg-repo-clone-resolving = {"   "}Resolving... {NUMBER($percent, maximumFractionDigits: 2)}%
msg-repo-clone-finishing_up = Finishing up...
msg-repo-clone-success = Cloned {$repo} into {$path}

help-cmd-repo-star = Add a star to a repo
msg-repo-star-success = Starred {$owner}/{$repo}!

help-cmd-repo-unstar = Take away a star from a repo
msg-repo-unstar-success = Removed star from {$owner}/{$repo}!

help-cmd-repo-star_status = Check your current starring status
help-arg-repo-star_status-list = List all starred repos instead of checking status
msg-repo-star-already_starred = You already starred this repo
msg-repo-unstar-already_unstarred = You already don't star this repo
msg-repo-star_status-starred = You have starred {$owner}/{$repo}
msg-repo-star_status-unstarred = You have not starred {$owner}/{$repo}
msg-repo-star_status-list-header = You star {$count} { $count ->
        [one] repo
        *[other] -> repos
    }
msg-repo-star_status-list-repo = Starred {$owner}/{$repo}

help-cmd-repo-delete = Delete a repository
help-cmd-repo-delete-long =
    Delete a repository

    This cannot be undone!
msg-repo-delete-confirmation_prompt = Are you sure you want to delete {$owner}/{$name}? (y/N)
    .yes =
        Yes
        yes
        Y
        y
    .no =
        No
        no
        N
        n
msg-repo-delete-success = Deleted {$owner}/{$repo}
msg-repo-delete-cancelled = Did not delete

help-cmd-repo-browse = Open a repository's page in your browser

help-cmd-repo-labels = Manage a repo's issue labels

help-cmd-repo-labels-view = Show a repo's labels
help-arg-repo-labels-view-archived = Show archived labels
msg-repo-label-view-archived = (archived)
msg-repo-label-view-no_description = (no description)

help-cmd-repo-labels-create = Create a new label
help-arg-repo-labels-create-name = Name of the new label. You may include a '/' here to namespace the label
help-arg-repo-labels-create-color = Color of the new label in hexadecimal format
help-arg-repo-labels-create-description = A description for the new label. If no argument is given, open the editor
help-arg-repo-labels-create-exclusive = Make this label exclusive with other labels in the same namespace
help-arg-repo-labels-create-archived = Create an archived label
msg-repo-label-create-success = Successfully created label {$label}

help-cmd-repo-labels-delete = Delete a label
help-arg-repo-labels-delete-id = The ID or name of the label to delete
msg-repo-label-delete-success = Successfully deleted label {$label}

help-cmd-repo-labels-edit = Edit a label
help-arg-repo-labels-edit-id = The ID or name of the label to edit
help-arg-repo-labels-edit-name = New name for the label
help-arg-repo-labels-edit-color = New color for the label
help-arg-repo-labels-edit-description = New description for the label. If no argument is given, open the editor
help-arg-repo-labels-edit-exclusive = New exclusive status
help-arg-repo-labels-edit-archived = New archived status
msg-repo-label-edit-success = Edited label: {$label}

help-cmd-repo-edit = Edit a repository's properties
help-arg-repo-edit-archived = Archive or unarchive
help-arg-repo-edit-default_branch = Set the default branch
help-arg-repo-edit-description = Set the description
help-arg-repo-edit-enable_prune = Remove obsolete remote-tracking references when mirroring
help-arg-repo-edit-mirror_interval = Set the interval for push mirrors. Use a string like 8h30m0s
help-arg-repo-edit-name = Set the repo's name
help-arg-repo-edit-private = Set this repository's private status
help-arg-repo-edit-template = Set if this repository should be a template repository
help-arg-repo-edit-website = Set a URL for this repository's website
help-arg-repo-edit-avatar = Path of the image to set the repository's avatar to
help-arg-repo-edit-unset_avatar = Remove the repo's currently set avatar
msg-repo-edit-avatar_file_not_found = { $path } does not exist.

help-cmd-repo-units = Manage a repo's units

help-cmd-repo-units-issues = Manage the issues unit
help-arg-repo-units-issues-enable = Enable or disable issues

help-cmd-repo-units-prs = Manage the pull requests unit
help-arg-repo-units-prs-enable = Enable or disable pull requests
help-arg-repo-units-prs-allow_fast_forward_only_merge = Allow fast-forward only merging
help-arg-repo-units-prs-allow_manual_merge = Allow manual merging
help-arg-repo-units-prs-allow_merge_commits = Allow merge commits
help-arg-repo-units-prs-allow_rebase = Allow rebase merging
help-arg-repo-units-prs-allow_rebase_explicit = Allow rebase merging with explicit merge commits
help-arg-repo-units-prs-allow_rebase_update = Allow updating PR branches by rebase
help-arg-repo-units-prs-allow_squash_merge = Allow squash merging
help-arg-repo-units-prs-autodetect_manual_merge = Automatically detect manual merges
help-arg-repo-units-prs-default_allow_maintainer_edit = Allow maintainer edits by default
help-arg-repo-units-prs-default_delete_branch_after_merge = Delete branch after merge by default
help-arg-repo-units-prs-default_merge_style = Default merge style
help-arg-repo-units-prs-default_update_style = Default update style
help-arg-repo-units-prs-ignore_whitespace_conflicts = Ignore whitespace merge conflicts

help-cmd-repo-units-actions = Manage the actions unit
help-arg-repo-units-actions-enable = Enable or disable actions

help-cmd-repo-units-wiki = Manage the wiki unit
help-arg-repo-units-wiki-enable = Enable or disable the wiki
help-arg-repo-units-wiki-branch = Set the branch used for the wiki
help-arg-repo-units-wiki-external_url = Set the URL for an external wiki
help-arg-repo-units-wiki-external_url-long =
    Set the URL for an external wiki

    If no URL is given, the external wiki is instead disabled.
help-arg-repo-units-wiki-globally_editable = Set the globally editable state of the wiki

help-cmd-repo-units-packages = Manage the packages unit
help-arg-repo-units-packages-enable = Enable or disable the package registry

help-cmd-repo-units-projects = Manage the projects unit
help-arg-repo-units-projects-enable = Enable or disable the project board

help-cmd-repo-units-releases = Manage the releases unit
help-arg-repo-units-releases-enable = Enable or disable releases

help-cmd-user-search = Search for a user by username
help-arg-user-search-query = The name to search for
msg-user-search-page_zero = There is no page 0
msg-user-search-fail = Search failed
msg-user-search-none = No users matched that query
msg-user-search-page_too_high = {$total_pages ->
        [one] There is only 1 page
       *[other] There are only {$total_pages} pages
    }
msg-user-search-footer =
    Showing {STYLE("bold")}{$first_index}{-dash}{$last_index}{STYLE("reset")} of {STYLE("bold")}{$total_results}{STYLE("reset")} results ({$page}/{$total_pages})
    {$more ->
        [yes] View more with the --page flag
       *[no] {""}
    }

help-cmd-user-view = View a user's profile page
help-arg-user-view-user = The name of the user to view
help-arg-user-view-user-long =
    The name of the user to view

    Omit to view your own page.
msg-user-view-header = {STYLE("bright-cyan", "bold")}{$username}{STYLE("reset")} {OPT($pronouns) ->
       *[none] {""}
        [some] {STYLE("light-grey")} {-dash} {STYLE("bold")}{$pronouns}{STYLE("reset")}
    }
    {$followers ->
        [one] {STYLE("bold")}1{STYLE("reset")} follower
       *[other] {STYLE("bold")}{$followers}{STYLE("reset")} followers
    } {-dash} {STYLE("bold")}{$following}{STYLE("reset")} following
    {OPT($website) ->
       *[none] {OPT($email) ->
           *[none] {""}
            [some] {STYLE("bold")}{$email}{STYLE("reset")}
        }
        [some] {OPT($email) ->
           *[none] {STYLE("bold")}{$website}{STYLE("reset")}
            [some] {STYLE("bold")}{$website}{STYLE("reset")} {-dash} {STYLE("bold")}{$email}{STYLE("reset")}
        }
    }
msg-user-view-joined_on = Joined on {STYLE("bold")}{DATETIME($joined, dateStyle: "medium")}{STYLE("reset")}

help-cmd-user-browse = Open a user's profile page in your browser
help-arg-user-browse-user = The name of the user to open in your browser
help-arg-user-browse-user-long =
    The name of the user to open in your browser

    Omit to view your own page.

help-cmd-user-follow = Follow a user
help-arg-user-follow-user = The name of the user to follow
msg-user-follow-success = Followed {$username}

help-cmd-user-unfollow = Unfollow a user
help-arg-user-unfollow-user = The name of the user to unfollow
msg-user-unfollow-success = Unfollowed {$username}

help-cmd-user-following = List everyone a user's follows
help-arg-user-following-user = The name of the user whose follows to list
help-arg-user-following-user-long =
    The name of the user whose follows to list

    Omit to view your own follows.
msg-user-following-none-other = {$user} isn't following anyone
msg-user-following-none-self = You aren't following anyone
msg-user-following-other = {$user} is following:
msg-user-following-self = You are following:

help-cmd-user-followers = List a user's followers
help-arg-user-followers-user = The name of the user whose followers to list
help-arg-user-followers-user-long =
    The name of the user whose followers to list

    Omit to view your own followers.
msg-user-followers-none-other = {$user} has no followers
msg-user-followers-none-self = You have no followers :(
msg-user-followers-other = {$user} is followed by:
msg-user-followers-self = You are followed by:

help-cmd-user-block = Block a user
help-arg-user-block-user = The name of the user to block
msg-user-block-success = Blocked {$user}

help-cmd-user-unblock = Unblock a user
help-arg-user-unblock-user = The name of the user to unblock
msg-user-unblock-success = Unblocked {$user}

help-cmd-user-repos = List a user's repositories
help-arg-user-repos-user = The name of the user whose repos to list
help-arg-user-repos-user-long =
    The name of the user whose repos to list

    Omit to view your own repos.
help-arg-user-repos-starred = List starred repos instead of owned repos
help-arg-user-repos-sort = Method by which to sort the list
help-arg-user-repos-page = Page of repos to get
msg-user-repos-none-starred-other = {$name} has not starred any repos
msg-user-repos-none-starred-self = You have not starred any repos
msg-user-repos-none-other = {$name} does not own any repos
msg-user-repos-none-self = You do not own any repos
msg-user-repos-list_footer =
    Showing {STYLE("bold")}{$first_index}{-dash}{$last_index}{STYLE("reset")} of {STYLE("bold")}{$total_results}{STYLE("reset")} results ({$page}/{$total_pages})
    {$more ->
        [yes] View more with the --page flag
       *[no] {""}
    }

help-cmd-user-orgs = List the organizations a user is a member of
help-arg-user-orgs-user = The name of the user to view org membership of
help-arg-user-orgs-user-long =
    The name of the user to view org membership of

    Omit to view your own orgs.
msg-user-orgs-none-other = {$user} is not a member of any organizations
msg-user-orgs-none-self = You are not a member of any organizations
msg-user-orgs-count = {$organizations ->
        [one] 1 organization
       *[other] {$organizations} organizations
    }

help-cmd-user-activity = List a user's recent activity
help-arg-user-activity-user = The name of the user to view the activity of
help-arg-user-activity-user-long =
    The name of the user to view the activity of

    Omit to view your own activity.
msg-activity-created_fork = {STYLE("bold")}{$actor}{STYLE("reset")} forked repository {STYLE("bold", "yellow")}{$parent_repo_name}{STYLE("reset")} to {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-created_mirror = {STYLE("bold")}{$actor}{STYLE("reset")} created mirror {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-created_repo = {STYLE("bold")}{$actor}{STYLE("reset")} created repository {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-renamed_repo = {STYLE("bold")}{$actor}{STYLE("reset")} renamed repository from {STYLE("bold", "yellow")}\"{$old_name}\"{STYLE("reset")} to {STYLE("bold", "yellow")}{$new_name}{STYLE("reset")}
msg-activity-starred_repo = {STYLE("bold")}{$actor}{STYLE("reset")} starred repository {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-watched_repo = {STYLE("bold")}{$actor}{STYLE("reset")} watched repository {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-pushed_commit = {STYLE("bold")}{$actor}{STYLE("reset")} pushed to {STYLE("bold", "bright-cyan")}{$branch}{STYLE("reset")} on {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-created_issue = {STYLE("bold")}{$actor}{STYLE("reset")} opened issue {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-created_pr = {STYLE("bold")}{$actor}{STYLE("reset")} created pull request {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-transferred_repo = {STYLE("bold")}{$actor}{STYLE("reset")} transferred repository {STYLE("bold", "yellow")}\"{$old_name}\"{STYLE("reset")} to {STYLE("bold", "yellow")}{$new_name}{STYLE("reset")}
msg-activity-pushed_tag = {STYLE("bold")}{$actor}{STYLE("reset")} pushed tag {STYLE("bold", "bright-cyan")}{$tag_name}{STYLE("reset")} to {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-commented_issue = {STYLE("bold")}{$actor}{STYLE("reset")} commented on issue {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-merged_pr = {STYLE("bold")}{$actor}{STYLE("reset")} merged pull request {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-closed_issue = {STYLE("bold")}{$actor}{STYLE("reset")} closed issue {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-reopened_issue = {STYLE("bold")}{$actor}{STYLE("reset")} reopened issue {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-closed_pr = {STYLE("bold")}{$actor}{STYLE("reset")} closed pr {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-reopened_pr = {STYLE("bold")}{$actor}{STYLE("reset")} reopened pr {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-deleted_tag = {STYLE("bold")}{$actor}{STYLE("reset")} deleted tag {STYLE("bold", "bright-cyan")}{$tag_name}{STYLE("reset")} from {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-deleted_branch = {STYLE("bold")}{$actor}{STYLE("reset")} deleted branch {STYLE("bold", "bright-cyan")}{$branch}{STYLE("reset")} from {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}
msg-activity-approved_pr = {STYLE("bold")}{$actor}{STYLE("reset")} approved {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-rejected_pr = {STYLE("bold")}{$actor}{STYLE("reset")} suggested changes for {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-commented_pr = {STYLE("bold")}{$actor}{STYLE("reset")} commented on pull request {STYLE("bold", "yellow")}{$repo_name}#{$number}{STYLE("reset")}
msg-activity-created_release = {STYLE("bold")}{$actor}{STYLE("reset")} created release {STYLE("bold", "bright-cyan")}{$release_name}{STYLE("reset")} on {STYLE("bold", "yellow")}{$repo_name}{STYLE("reset")}

help-cmd-user-edit = Edit your user settings

help-cmd-user-edit-bio = Set your bio
help-arg-user-edit-bio-content = The new description. Leave this out to open your editor

help-cmd-user-edit-name = Set your full name
help-arg-user-edit-name-name = The new name
help-arg-user-edit-name-unset = Remove your name from your profile
msg-user-edit-name-removal_hint = Use --unset to remove your name from your profile

help-cmd-user-edit-pronouns = Set your pronouns
help-arg-user-edit-pronouns-pronouns = The new pronouns
help-arg-user-edit-pronouns-unset = Remove your pronouns from your profile
msg-user-edit-pronouns-removal_hint = Use --unset to remove your pronouns from your profile

help-cmd-user-edit-location = Set your location
help-arg-user-edit-location-location = The new location
help-arg-user-edit-location-unset = Remove your location from your profile
msg-user-edit-location-removal_hint = Use --unset to remove your location from your profile

help-cmd-user-edit-activity = Set your activity visibility
help-arg-user-edit-activity-visibility = The visibility of your activity

help-cmd-user-edit-email = Manage the email addresses associated with your account
help-arg-user-edit-email-visibility = Set the visibility of your email address
help-arg-user-edit-email-add = Add a new email address
help-arg-user-edit-email-rm = Remove an email address

help-cmd-user-edit-website = Set your linked website
help-arg-user-edit-website-url = Your website URL
help-arg-user-edit-website-unset = Remove your website from your profile
msg-user-edit-website-removal_hint = Use --unset to remove your website from your profile

help-cmd-user-key = Manage SSH keys

help-cmd-user-key-list = List your SSH keys
help-arg-user-key-list-verbose = Show detailed information about every key
msg-user-key-list-count = total keys: {$keys}
msg-user-key-list-header = {STYLE("bold")}Key {STYLE("bright-magenta")}{$id}{STYLE("reset")}
msg-user-key-list-title = {STYLE("bold")}Title:{STYLE("reset")}       {STYLE("bright-cyan")}{$title}{STYLE("reset")}
msg-user-key-list-created_at = {STYLE("bold")}Created At:{STYLE("reset")}  {STYLE("bright-cyan")}{DATETIME($created_at, dateStyle: "short", timeStyle: "medium")}{STYLE("reset")}
msg-user-key-list-type = {STYLE("bold")}Type:{STYLE("reset")}        {STYLE("bright-cyan")}{$key_type}{STYLE("reset")}
msg-user-key-list-fingerprint = {STYLE("bold")}Fingerprint:{STYLE("reset")} {STYLE("bright-cyan")}{$fingerprint}{STYLE("reset")}

help-cmd-user-key-view = View an SSH key
help-arg-user-key-view-id = The ID of the key to view as shown in `user key list`

help-cmd-user-key-delete = Delete an SSH key
help-arg-user-key-delete-id = The ID of the key to delete as shown in `user key list`
msg-user-key-delete-success = successfully deleted key with ID {$id}

help-cmd-user-key-upload = Upload an SSH key
help-arg-user-key-upload-keyfile = Path to the key file or '-' to read from stdin. If omitted, will try to guess
help-arg-user-key-upload-title = The title of the key. If omitted, will try to guess from the file content
help-arg-user-key-upload-force = If provided, will skip checks against accidentally uploading private keys
help-arg-user-key-upload-read_only = If provided, the new key will only have read access
msg-user-key-upload-home_not_found = Couldn't locate home directory. Please provide an explicit path for the key file.
msg-user-key-upload-keys_not_found = No keys found.
msg-user-key-upload-confirm_key_file_prompt =
        Guessed key file: {$path}
        Does this look good? [Y/N]
    .yes =
        Yes
        yes
        Y
        y
    .no =
        No
        no
        N
        n
msg-user-key-upload-title_unconfirmed = Title was not confirmed
msg-user-key-upload-file_unconfirmed = File path was not confirmed
msg-user-key-add-file_unconfirmed = User didn't confirm guessed key file.
msg-user-key-add-unexpected_extension =
    '{$path}' doesn't end in '.pub'. Are you sure this isn't a private key?
     If you want to proceed anyways, add --force.
msg-user-key-add-invalid_key =
    '{$path}' looks like a private key or invalid data!
     If you want to proceed anyways, add --force.
msg-user-key-add-no_title = Couldn't guess key title, please provide one explicitly and check your key file.
msg-user-key-upload-confirm_key_title_prompt =
        Guessed title: {STYLE("bright-cyan")}{$title}{STYLE("reset")}
        Does this look good? [Y/N]
    .yes =
        Yes
        yes
        Y
        y
    .no =
        No
        no
        N
        n
msg-user-key-add-title_unconfirmed = User didn't confirm guessed title.
msg-user-key-add-success = Key created successfully!

help-cmd-user-gpg = Manage GPG keys

help-cmd-user-gpg-list = List your GPG keys
help-arg-user-gpg-list-verbose = Show detailed information about every key
msg-user-gpg-list-count = total keys: {$keys}
msg-user-gpg-list-header = {STYLE("bold")}Key {STYLE("bright-magenta")}{$id}{STYLE("reset")}
msg-user-gpg-list-key_id = {STYLE("bold")}Key ID:{STYLE("reset")}              {STYLE("bright-cyan")}{$key_id}{STYLE("reset")}
msg-user-gpg-list-can_sign = {STYLE("bold")}Can Sign:{STYLE("reset")}            {$can_sign ->
        [yes] {STYLE("bright-green")}true{STYLE("reset")}
       *[no] {STYLE("bright-red")}false{STYLE("reset")}
    }
msg-user-gpg-list-can_encrypt_comms = {STYLE("bold")}Can Encrypt Comms:{STYLE("reset")}   {$can_encrypt_comms ->
        [yes] {STYLE("bright-green")}true{STYLE("reset")}
       *[no] {STYLE("bright-red")}false{STYLE("reset")}
    }
msg-user-gpg-list-can_encrypt_storage = {STYLE("bold")}Can Encrypt Storage:{STYLE("reset")} {$can_encrypt_storage ->
        [yes] {STYLE("bright-green")}true{STYLE("reset")}
       *[no] {STYLE("bright-red")}false{STYLE("reset")}
    }
msg-user-gpg-list-can_certify = {STYLE("bold")}Can Certify:{STYLE("reset")}         {$can_certify ->
        [yes] {STYLE("bright-green")}true{STYLE("reset")}
       *[no] {STYLE("bright-red")}false{STYLE("reset")}
    }
msg-user-gpg-list-verified = {STYLE("bold")}Verified:{STYLE("reset")}            {$verified ->
        [yes] {STYLE("bright-green")}true{STYLE("reset")}
       *[no] {STYLE("bright-red")}false{STYLE("reset")}
    }
msg-user-gpg-list-email = {STYLE("bright-cyan")}{$email}{STYLE("reset")} {$verified ->
        [yes] verified
       *[no] not verified
    }
msg-user-gpg-list-subkey = {STYLE("bold")}Subkey {STYLE("bright-magenta")}{$id}{STYLE("reset")}:

help-cmd-user-gpg-view = View a GPG key
help-arg-user-gpg-view-id = The ID of the GPG key to view as shown in `user gpg list`

help-cmd-user-gpg-upload = Upload a GPG key
help-arg-user-gpg-upload-key = The key to add. This can be anything the GPG CLI recognizes such as an email associated with the key or the key ID
help-arg-user-gpg-upload-no_verify = Skip the verification step. With this disabled, you can only add keys with emails associated with your account
msg-user-gpg-upload-exporting = Exporting key...
msg-user-gpg-upload-export_failed = Failed to export key. {OPT($status_code) ->
       *[none] {""}
        [some] GPG status: {$status_code}
    }
msg-user-gpg-upload-success = Key successfully added!

help-cmd-user-gpg-verify = Verifies a GPG key
help-cmd-user-gpg-verify-long =
    Verifies a GPG key

    You need to have the to-be-verified key installed locally in order to
    sign some data with it.
    This command requires `gpg` to be installed.
help-arg-user-gpg-verify-id = The ID of the GPG key to verify as shown in `user gpg list`
msg-user-gpg-verify-fetching_token = Fetching verification token...
msg-user-gpg-verify-signing_token = Signing verification token with key '{$key_name}'...
msg-user-gpg-verify-signing_failed = Failed to sign verification token. {OPT($status_code) ->
       *[none] {""}
        [some] GPG status: {$status_code}
    }
msg-user-gpg-verify-key_to_verify = Verifying this key:
msg-user-gpg-verify-success = Verification successful!

help-cmd-user-gpg-delete = Delete a GPG key. This will un-verify all commits signed with that key!
help-arg-user-gpg-delete-id = The ID of the GPG key to delete as shown in `user gpg list`
help-arg-user-gpg-delete-force = Don't ask for confirmation
msg-user-gpg-delete-confirmation_prompt =
        Deleting a GPG key will cause all commits signed by that key to become unverified! Continue?
    .yes =
        Yes
        yes
        Y
        y
    .no =
        No
        no
        N
        n
msg-user-gpg-delete-unconfirmed = User aborted process.
msg-user-gpg-delete-success = Key with ID {$id} deleted successfully.

help-cmd-release-create = Create a new release
help-arg-release-create-create_tag = Create a new corresponding tag for this release. Defaults to release's name
help-arg-release-create-tag = Pre-existing tag to use
help-arg-release-create-tag-long =
    Pre-existing tag to use

    If you need to create a new tag for this release, use `--create-tag`
help-arg-release-create-attach = Include a file as an attachment
help-arg-release-create-attach-long =
    Include a file as an attachment

    `--attach=<FILE>` will set the attachment's name to the file name
    `--attach=<FILE>:<ASSET>` will use the provided name for the attachment
help-arg-release-create-body = Text of the release body
help-arg-release-create-body-long =
    Text of the release body

    Using this flag without an argument will open your editor.
help-arg-release-create-body-file = The text body of the release, to read from a file
msg-release-create-must_specify_tag = must select tag with `--tag` or `--create-tag`
msg-release-create-tag_flags_conflict =`--tag` and `--create-tag` are mutually exclusive; please pick just one
msg-release-create-success = Created release {$name}

help-cmd-release-edit = Edit a release's info
help-arg-release-edit-tag = Corresponding tag for this release
help-arg-release-edit-body = Text of the release body
help-arg-release-edit-body-long =
    Text of the release body

    Using this flag without an argument will open your editor.

help-cmd-release-delete = Delete a release

help-cmd-release-list = List all the releases on a repo

help-cmd-release-view = View a release's info

help-cmd-release-browse = Open a release in your browser

help-cmd-release-asset = Commands on a release's attached files

help-cmd-release-asset-create = Create a new attachment on a release

help-cmd-release-asset-delete = Remove an attachment from a release

help-cmd-release-asset-download = Download an attached file
help-cmd-release-asset-download-long =
    Download an attached file

    Use `source.zip` or `source.tar.gz` to download the repo archive


msg-release-list-entry = {$name} {$state ->
       *[neither] {""}
        [draft] (draft)
        [prerelease] (prerelease)
        [both] (draft, prerelease)
    }

msg-release-view-header = {$name}
    By {$author} on {DATETIME($created_at, dateStyle: "long")}

msg-release-asset-create-success = Added attachment `{$asset}` to {$release}

msg-release-asset-delete-success = Removed attachment `{$asset}` from {$release}

msg-release-asset-download-success = { OPT($file) ->
       *[none] Downloaded {$asset}
        [some] Downloaded {$asset} into {$file}
    }

help-cmd-tag-create = Create a new tag
help-arg-tag-create-body = Text of the tag's message
help-arg-tag-create-body-long =
    Text of the tag's message

    Using this flag without an argument will open your editor.
msg-tag-create-success = created tag {$name}

help-cmd-tag-delete = Delete a tag
msg-tag-delete-success = deleted tag {$name}

help-cmd-tag-list = List all the tags on a repo

help-cmd-tag-view = View a tag's info

help-arg-version-check = Checks for updates
msg-version-update_check-hint = Check for a new version with `forge version --check`
msg-version-update_check-current = Up to date!
msg-version-update_check-behind =
    New version available: {$new_version}
    Get it at {$url}
msg-version-update_check-ahead = You are ahead of the latest published version

help-arg-wiki-clone-ssh = Clone the repo over SSH instead of HTTP(S)
help-arg-wiki-clone-identity_file = An SSH key file to use when cloning over SSH
msg-wiki-clone-success = Cloned {$repo}'s wiki into {$path}

msg-auth-login-oauth-login-open-fail = Unable to process OAuth login due to an error

msg-repo-watch-success = You are now watching {$owner}/{$repo}
msg-repo-watch-already_subscribed = You already watch this repo
msg-repo-unwatch-already_unsubscribed = You already don't watch this repo
msg-repo-unwatch-success = You no longer watch {$owner}/{$repo}
msg-repo-watch_status-subscribed = You are subscribed to {$owner}/{$repo}
msg-repo-watch_status-unsubscribed = You are not subscribed to {$owner}/{$repo}
msg-repo-watch_status-list-header = You are subscribed to {$count} repos
msg-repo-watch_status-list-repo = Subscribed to {$owner}/{$repo}
help-cmd-repo-watch = Subscribe to a repo
help-cmd-repo-unwatch = Unsubscribe from a repo
help-cmd-repo-watch_status = Check your current watch status
help-arg-repo-watch_status-list = List all watched repos instead of checking status

help-arg-cwd = Sets the working directory to <CWD>

msg-project-dir-not-found = Could not find project directory for forge
msg-old-key-file-read =
    Note: Reading from the keys file in the old location.
        That location is deprecated. The keys file will be saved to the new location.
msg-save-migrated-key-file-fail =
    {STYLE("bold", "yellow")}Could not migrate key file to the new location!
    Please ensure, forge can write to {$path}. The old file has not been modified.{STYLE("reset")}

help-cmd-milestone-search = Search for milestones
help-arg-milestone-search-state = Filter milestones by state
help-arg-milestone-search-title = Filter milestones by title
help-cmd-milestone-create = Create a new milestone
help-arg-milestone-create-title = Title of the milestone to create
help-arg-milestone-create-description = Description of the milestone to create. Omit to invoke editor
help-arg-milestone-create-state = State of the milestone to create
help-cmd-milestone-view = View a milestone
help-arg-milestone-view-title = Title or ID of the milestone to view
help-cmd-milestone-edit = Edit a milestone
help-arg-milestone-edit-title = Title of the milestone to edit
help-arg-milestone-edit-description = New description for the milestone
help-arg-milestone-edit-state = New state for the milestone
help-arg-milestone-edit-new_title = New title for the milestone
help-cmd-milestone-delete = Delete a milestone
help-arg-milestone-delete-title = Title or ID of the milestone to delete

msg-milestone-search-total = {$milestones ->
        [one] 1 milestone
       *[other] {$milestones} milestones
    }
msg-milestone-search-entry = {$title} { $state ->
       *[open] ({STYLE("green")}open{STYLE("reset")})
        [closed] ({STYLE("red")}closed{STYLE("reset")})
    } {$open} open, {$closed} closed
msg-milestone-view =
    {STYLE("bold")}{$title}{STYLE("reset")} { $state ->
       *[open] ({STYLE("green")}open{STYLE("reset")})
        [closed] ({STYLE("red")}closed{STYLE("reset")})
    }
    {STYLE("bright-blue")}{$open} open, {$closed} closed{STYLE("reset")}
    created {$created_at}, updated {$updated_at}
    { OPT($due_on) ->
        [none] no due date
       *[some] due: {$due_on}
    }{ OPT($description) ->
        [none] {""}
       *[some] {""}

       {$description}
    }
msg-milestone-deleted = Milestone deleted
msg-milestone-not_found = Could not find the specified milestone
