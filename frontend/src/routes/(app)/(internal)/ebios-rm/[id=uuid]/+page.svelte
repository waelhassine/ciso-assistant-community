<script lang="ts">
	import * as m from '$paraglide/messages';
	import { safeTranslate } from '$lib/utils/i18n';
	import Tile from './Tile.svelte';
	import { page } from '$app/stores';
	import type { PageData, ActionData } from './$types';
	import { breadcrumbObject } from '$lib/utils/stores';
	import type { ModalComponent, ModalSettings, ModalStore } from '@skeletonlabs/skeleton';
	import { getModalStore } from '@skeletonlabs/skeleton';
	import CreateModal from '$lib/components/Modals/CreateModal.svelte';
	import MissingConstraintsModal from '$lib/components/Modals/MissingConstraintsModal.svelte';
	import { checkConstraints } from '$lib/utils/crud';
	import { goto } from '$app/navigation';
	import { getSecureRedirect } from '$lib/utils/helpers';

	const modalStore: ModalStore = getModalStore();

	export let data: PageData;
	export let form: ActionData;

	$: breadcrumbObject.set(data.data);

	const workshopsData = {
		ws1: [
			{
				title: safeTranslate(m.ebiosWs1_1()),
				status: data.data.meta.workshops[0].steps[0].status,
				href: `${$page.url.pathname}/workshop-1/ebios-rm-study?activity=one&next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs1_2()),
				status: data.data.meta.workshops[0].steps[1].status,
				href: `${$page.url.pathname}/workshop-1/ebios-rm-study?activity=two&next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs1_3()),
				status: data.data.meta.workshops[0].steps[2].status,
				href: `${$page.url.pathname}/workshop-1/feared-events?next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs1_4()),
				status: data.data.meta.workshops[0].steps[3].status,
				href: `${$page.url.pathname}/workshop-1/baseline?next=${$page.url.pathname}`
			}
		],
		ws2: [
			{
				title: safeTranslate(m.ebiosWs2_1()),
				status: data.data.meta.workshops[1].steps[0].status,
				href: `${$page.url.pathname}/workshop-2/ro-to?activity=one&next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs2_2()),
				status: data.data.meta.workshops[1].steps[1].status,
				href: `${$page.url.pathname}/workshop-2/ro-to?activity=two&next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs2_3()),
				status: data.data.meta.workshops[1].steps[2].status,
				href: `${$page.url.pathname}/workshop-2/ro-to?activity=three&next=${$page.url.pathname}`
			}
		],
		ws3: [
			{
				title: safeTranslate(m.ebiosWs3_1()),
				status: data.data.meta.workshops[2].steps[0].status,
				href: `${$page.url.pathname}/workshop-3/ecosystem?activity=one&next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs3_2()),
				status: data.data.meta.workshops[2].steps[1].status,
				href: `${$page.url.pathname}/workshop-3/strategic-scenarios?next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs3_3()),
				status: data.data.meta.workshops[2].steps[2].status,
				href: `${$page.url.pathname}/workshop-3/ecosystem?activity=three&next=${$page.url.pathname}`
			}
		],
		ws4: [
			{
				title: safeTranslate(m.ebiosWs4_1()),
				status: 'to_do',
				href: `${$page.url.pathname}/workshop-4/operational-scenario?activity=one&next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs4_2()),
				status: 'to_do',
				href: `${$page.url.pathname}/workshop-4/operational-scenario?activity=two&next=${$page.url.pathname}`
			}
		],
		ws5: [
			{
				title: safeTranslate(m.ebiosWs5_1()),
				status: data.data.meta.workshops[4].steps[0].status,
				href: '#'
			},
			{
				title: safeTranslate(m.ebiosWs5_2()),
				status: data.data.meta.workshops[4].steps[1].status,
				href: `${$page.url.pathname}/workshop-5/risk-analyses?next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs5_3()),
				status: data.data.meta.workshops[4].steps[2].status,
				href: `${$page.url.pathname}/workshop-5/risk-analyses?next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs5_4()),
				status: data.data.meta.workshops[4].steps[3].status,
				href: `${$page.url.pathname}/workshop-5/risk-analyses?next=${$page.url.pathname}`
			},
			{
				title: safeTranslate(m.ebiosWs5_5()),
				status: data.data.meta.workshops[4].steps[4].status,
				href: `${$page.url.pathname}/workshop-5/risk-analyses?next=${$page.url.pathname}`
			}
		]
	};

	function modalCreateForm(): void {
		let modalComponent: ModalComponent = {
			ref: CreateModal,
			props: {
				form: data.createRiskAnalysisForm,
				model: data.riskModel
			}
		};
		let modal: ModalSettings = {
			type: 'component',
			component: modalComponent,
			// Data
			title: safeTranslate('add-' + data.riskModel.localName)
		};
		if (
			checkConstraints(data.createRiskAnalysisForm.constraints, data.riskModel.foreignKeys).length >
			0
		) {
			modalComponent = {
				ref: MissingConstraintsModal
			};
			modal = {
				type: 'component',
				component: modalComponent,
				title: m.warning(),
				body: safeTranslate('add-' + data.riskModel.localName).toLowerCase(),
				value: checkConstraints(data.createRiskAnalysisForm.constraints, data.riskModel.foreignKeys)
			};
		}
		modalStore.trigger(modal);
	}

	$: if (form && form.redirect) {
		goto(getSecureRedirect(form.redirect));
	}
</script>

<div class="h-full w-full p-8">
	<div
		class="card bg-white shadow-lg w-full h-full grid xl:grid-cols-3 lg:grid-cols-2 md:grid-cols-1 gap-8 p-8"
	>
		<Tile workshop={1} title={m.ebiosWs1()} accent_color="bg-pink-600" meta={workshopsData.ws1} />
		<Tile
			workshop={2}
			title={m.ebiosWs2()}
			accent_color="bg-fuchsia-900"
			meta={workshopsData.ws2}
		/>
		<Tile workshop={3} title={m.ebiosWs3()} accent_color="bg-teal-500" meta={workshopsData.ws3} />
		<Tile workshop={4} title={m.ebiosWs4()} accent_color="bg-yellow-600" meta={workshopsData.ws4} />
		<Tile
			workshop={5}
			title={m.ebiosWs5()}
			accent_color="bg-red-500"
			meta={workshopsData.ws5}
			createRiskAnalysis={true}
		>
			<div slot="addRiskAnalysis">
				<button class="flex flex-col text-left hover:text-purple-800" on:click={modalCreateForm}>
					<span
						class="absolute flex items-center justify-center w-8 h-8 bg-gray-100 rounded-full -start-4 ring-4 ring-white"
					>
						<i class="fa-solid fa-clipboard-check"></i>
					</span>
					<h3 class="font-medium leading-tight">{m.activity()} 1</h3>
					<p class="text-sm">{safeTranslate(m.ebiosWs5_1())}</p>
				</button>
			</div>
		</Tile>
		<Tile title={m.summary()} accent_color="bg-purple-800" />
	</div>
</div>
