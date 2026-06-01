<script lang="ts">
	import { slide } from 'svelte/transition';
	import Button from './Button.svelte';
	import { onMount } from 'svelte';

	let browser = false;
	onMount(() => {
		browser = true;
	});

	export let isCopied: boolean;
	export let value: string;
	export let jsIsEnabled: boolean;

	let buttonText = jsIsEnabled ? 'Copy to clipboard' : 'Generate Webhook URL';
	let buttonAlt = jsIsEnabled
		? 'Copy the webhook URL to your clipboard'
		: 'Generate a unique URL to forward listen events to';

	const copyToClipboard = async (e: Event) => {
		console.log('Copy button clicked, browser:', browser, 'value:', value);
		e.preventDefault();
		if (!browser) {
			console.log('Not in browser context');
			return;
		}
		if (!navigator?.clipboard?.writeText) {
			console.log('Clipboard API not available');
			return;
		}
		try {
			await navigator.clipboard.writeText(value);
			console.log('Text copied successfully');
			isCopied = true;
		} catch (error) {
			console.error('Failed to copy to clipboard:', error);
		}
	};
</script>

<div transition:slide|local>
	<Button
		type="button"
		title={!isCopied ? buttonAlt : 'URL already copied'}
		bind:isActioned={isCopied}
		on:click={copyToClipboard}
	>
		{!isCopied ? buttonText : 'Copied!'}
	</Button>
	<div style="margin-top: 1rem; padding: 1rem; background: #f0f0f0; border-radius: 4px; word-break: break-all; font-size: 0.8rem;">
		<strong>Generated URL:</strong><br />
		{value}
	</div>
</div>
