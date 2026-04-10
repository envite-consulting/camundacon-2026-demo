# AI Agent Chat With Tools Example

This example demonstrates how to deploy and run an AI-driven chat process in Camunda 8, where an AI agent can answer questions and use external tools (APIs, scripts, etc.) to provide more accurate responses. The process showcases tool integration, user feedback, and human-in-the-loop capabilities.

---

## Prerequisites

A full Camunda 8 deployment on STACKIT as described in this repository is required, including:

- Camunda 8 (Orchestration Cluster + Web Modeler + Console)
- `stackit-modelserving-token` module deployed and wired into `camunda-workflow-engine` (provides the STACKIT AI Model Serving token as Vault secret `modelserving-token`)

All of the above are provisioned together via `environments/single-region`.

---

## Secrets & Configuration

This example uses the **STACKIT AI Model Serving** service for LLM inference. The required API token is managed automatically by the infrastructure:

- The `stackit-modelserving-token` module generates and rotates the token and exports it as a Vault secret.
- The `camunda-workflow-engine` module creates a Kubernetes secret (`modelserving-token`) from it via External Secrets Operator.
- The secret is mounted into the Camunda Connectors pod via Helm configuration, making it available as a connector secret (`STACKIT_AI_Model_Serving_Token`).

For details on how connector secrets work in Camunda Self-Managed, see the [Camunda Connectors Configuration Docs](https://docs.camunda.io/docs/self-managed/components/connectors/connectors-configuration/#secrets).

The AI model endpoint and model configuration are already set in the process model. No manual secret setup is needed.

---

## How to Deploy & Run

1. **Import all files into the Web Modeler**
    - Open Camunda Web Modeler.
    - Import **all files** from the `ai-agent-chat-with-tools/` folder

2. **Publish the Element Templates**
    - In the Web Modeler, publish the following element templates for the project:
        - `AI Agent Sub-process`
        - `AI Agent Task`
        - `REST Outbound Connector`

   **Important: Depending on the version number specified when publishing, the connector templates in the process model may need to be re-selected manually after publishing a new version.**

3. **Deploy the Process**
    - Deploy the process to your Camunda 8 cluster.

4. **Start a New Instance**
    - Use the Web Modeler to start an instance by filling out the form.
    - Alternatively, use Tasklist to fill out the form and start a new instance.

5. **Interact**
    - The agent will respond, possibly using tools.

---

## BPMN Process Overview

The process (`ai-agent-chat-with-tools.bpmn`) works as follows:

1. **Start Event**: User submits an initial chat request via a form.
2. **AI Agent Task**: The Agentic AI connector receives the request, context, and available tools. It generates a response and may request tool calls.
3. **Tool Call Gateway**: If the agent wants to use tools, the process enters the `Agent Tools` ad-hoc sub-process.
4. **Agent Tools Sub-Process**: For each tool call requested by the agent, the corresponding task is executed. Tools include:
	- Get Date and Time
	- Load user by ID (HTTP API)
	- List users (HTTP API)
	- Search recipe (HTTP API)
	- Superflux product calculation (script)
	- Ask human to send email (user task)
	- Send email (script)
	- Fetch a joke (HTTP API)
	- Fetch URL (HTTP API)
5. **Loopback**: Tool results are returned to the agent, which may generate further tool calls or a final answer.
6. **User Feedback**: The user is asked if they are satisfied with the answer.
	- If not, the process loops for follow-up.
	- If yes, the process ends.

**Key Features:**
- Dynamic tool invocation by the agent
- Human-in-the-loop for actions like sending emails
- Extensible: add your own tools as new tasks in the sub-process

---

## Example Usage

Example inputs which can be entered in the initial form:

- `Send Ervin a joke`: this will need to do multiple tool calling steps to find a user named "Ervin", to fetch a joke
  and to compose an e-mail for the "Ask human to send email" task. The email sending user can provide feedback to update
  the message such as "include emojis" or "include a spanish translation".
- `Tell me about this document` can be used to analyze a PDF document with the file upload picker provided in the initial form.