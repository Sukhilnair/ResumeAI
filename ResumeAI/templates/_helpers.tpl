{{/*
Create a default fully qualified name.
*/}}
{{- define "ResumeAI.fullname" -}}
{{- printf "%s-%s" .Release.Name "resumeai" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a chart name with the release name.
*/}}
{{- define "ResumeAI.name" -}}
{{- .Chart.Name | quote -}}
{{- end -}}

{{/*
Common labels for all resources.
*/}}
{{- define "ResumeAI.labels" -}}
app: {{ include "ResumeAI.name" . }}
chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
release: {{ .Release.Name }}
heritage: {{ .Release.Service }}
{{- end -}}
