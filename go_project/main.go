package main

// Provide your ChatGPT in line 33

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strings"

	"github.com/atotto/clipboard"
)

func copy_to_clipboard(text string) {
	err := clipboard.WriteAll(text)
	if err != nil {
		fmt.Println("Error copying text to clipboard:", err)
		return
	}
}

func extract_text(text, stoppingPointText string) string {
	splitText := strings.Split(text, stoppingPointText)
	if len(splitText) > 0 {
		result := strings.TrimSpace(splitText[0])
		result = strings.Trim(result, "\"'")
		return result
	}
	return ""
}

func main() {
	token := ""

	clipboard_content, err := clipboard.ReadAll()
	if err != nil {
		fmt.Println("Error reading clipboard:", err)
		return
	}

	fmt.Println("Clipboard content:\n\n", clipboard_content)

	headers := map[string]string{
		"Content-Type":  "application/json",
		"Authorization": "Bearer " + token,
	}

	jsonData := map[string]interface{}{
		"model": "gpt-3.5-turbo",
		"messages": []map[string]string{
			{"role": "user", "content": "Fix the grammar errors and at the end list out the mistakes made:\n\n " + clipboard_content},
		},
	}

	jsonValue, _ := json.Marshal(jsonData)

	req, err := http.NewRequest("POST", "https://api.openai.com/v1/chat/completions", strings.NewReader(string(jsonValue)))
	if err != nil {
		fmt.Println("Error creating HTTP request:", err)
		return
	}

	for key, value := range headers {
		req.Header.Set(key, value)
	}

	client := &http.Client{}
	response, err := client.Do(req)
	if err != nil {
		fmt.Println("Error making HTTP request:", err)
		return
	}
	defer response.Body.Close()

	var responseData map[string]interface{}
	err = json.NewDecoder(response.Body).Decode(&responseData)
	if err != nil {
		fmt.Println("Error decoding JSON response:", err)
		return
	}

	choices := responseData["choices"].([]interface{})
	firstChoice := choices[0].(map[string]interface{})
	message := firstChoice["message"].(map[string]interface{})
	content := message["content"].(string)

	if strings.Contains(content, "Mistakes made:") {
		extractedText := extract_text(content, "Mistakes made:")
		copy_to_clipboard(extractedText)
		fmt.Println("\n\nExtracted content:", extractedText)
	} else if strings.Contains(content, "Mistakes:") {
		extractedText := extract_text(content, "Mistakes:")
		copy_to_clipboard(extractedText)
		fmt.Println("\n\nExtracted content:", extractedText)
	} else {
		fmt.Println("Text mismatch")
		return
	}

	fmt.Println("\n\n" + content)
	var exit_statement string
	fmt.Scanln(&exit_statement)
	fmt.Println(exit_statement)
}