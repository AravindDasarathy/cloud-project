resource "google_project_iam_binding" "iam_binding" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.key
  members = var.members
}
